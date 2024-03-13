{ config, pkgs, inputs, ... }:{
  home.packages = with pkgs; [ inputs.longcut.packages.${pkgs.system}.default ];

  xdg.configFile."longcut/longcut.yaml".source =
    pkgs.substituteAll { src = ./longcut.yaml.template; };
}
