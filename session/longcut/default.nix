{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  theme = import ../../theme/lib.nix { pkgs = pkgs; };
  package = inputs.longcut.packages.${pkgs.stdenv.hostPlatform.system}.default;
  baseConfig = import ./longcut.nix { inherit pkgs theme; };
  essentialPackages = with pkgs; [
    bluez
    brightnessctl
    dunst
    gpick
    i3
    jq
    libnotify
    networkmanager
    playerctl
    pipewire
    rofi
    scrot
    translate-shell
    xclip
    xdotool
    xorg.xprop
    xsel
    wireplumber
  ];
  mergeHelpers = rec {
    listToAttrset = lst: lib.foldl' (acc: item: acc // { "${item.name}" = item; }) { } lst;

    namesInOrder =
      lists:
      lib.foldl' (
        acc: item:
        let
          nm = item.name;
        in
        if lib.elem nm acc then acc else acc ++ [ nm ]
      ) [ ] lists;

    isNamedList = lst: lib.isList lst && lib.all (item: lib.isAttrs item && item ? name) lst;

    mergeNamedLists =
      left: right:
      let
        mergedMap = mergeAttrs (listToAttrset left) (listToAttrset right);
        names = namesInOrder (left ++ right);
      in
      lib.map (name: builtins.getAttr name mergedMap) names;

    mergeValues =
      left: right:
      if lib.isAttrs left && lib.isAttrs right then
        mergeAttrs left right
      else if lib.isList left && lib.isList right then
        if isNamedList left && isNamedList right then mergeNamedLists left right else left ++ right
      else
        right;

    mergeAttrs =
      left: right:
      let
        keysRaw = builtins.attrNames left ++ builtins.attrNames right;
        keys = lib.foldl' (acc: key: if lib.elem key acc then acc else acc ++ [ key ]) [ ] keysRaw;
      in
      lib.foldl' (
        acc: key:
        let
          hasLeft = builtins.hasAttr key left;
          hasRight = builtins.hasAttr key right;
          value =
            if hasLeft && hasRight then
              mergeValues (builtins.getAttr key left) (builtins.getAttr key right)
            else if hasRight then
              builtins.getAttr key right
            else
              builtins.getAttr key left;
        in
        acc // { "${key}" = value; }
      ) { } keys;
  };
  mergeConfigs = configs: lib.foldl' (acc: cfg: mergeHelpers.mergeAttrs acc cfg) { } configs;
in
{
  options.longcut.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Longcut shortcuts and service.";
  };

  options.longcut.baseConfig = lib.mkOption {
    type = lib.types.attrs;
    default = baseConfig;
    description = "Base Longcut configuration that fragments extend.";
  };

  options.longcut.fragments = lib.mkOption {
    type = lib.types.listOf lib.types.attrs;
    default = [ ];
    description = "Additional Longcut configuration fragments appended to the base config.";
  };

  options.longcut.extraPackages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    description = "Extra packages to install when Longcut is enabled.";
  };

  config = lib.mkIf config.longcut.enable (
    let
      mergedConfig = mergeConfigs ([ config.longcut.baseConfig ] ++ config.longcut.fragments);
      configFile = pkgs.writeText "longcut.yaml" (lib.generators.toYAML { } mergedConfig);
      configCheckOk =
        pkgs.runCommand "longcut-config-check"
          {
            nativeBuildInputs = [ package ];
          }
          ''
            ${package}/bin/longcut --config-file ${configFile} --check-config-only

            touch $out
          '';
    in
    {
      assertions = [
        {
          assertion = builtins.pathExists configCheckOk;
          message = "Longcut configuration validation failed";
        }
      ];

      home-manager.users.satajo = {
        home.packages = [
          package
        ]
        ++ essentialPackages
        ++ config.longcut.extraPackages;

        systemd.user.services.longcut = {
          Unit = {
            Description = "Longcut shortcut manager";
            After = [ "graphical-session-pre.target" ];
            PartOf = [ "graphical-session.target" ];
          };

          Service = {
            Type = "simple";
            ExecStart = "${pkgs.runtimeShell} -lc '${package}/bin/longcut --config-file ${configFile}'";
            KillMode = "process";
            Restart = "always";
            RestartSec = "1s";
          };

          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
    }
  );
}
