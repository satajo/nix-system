{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    longcut = {
      url = "github:satajo/longcut";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      hosts = builtins.attrNames (builtins.readDir ./host);
      system = "x86_64-linux";
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      mkSystem =
        hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs pkgs-unstable;
          };

          modules = [
            home-manager.nixosModules.default
            ./configuration.nix
            ./host/${hostname}/configuration.nix
            ./host/${hostname}/hardware-configuration.nix
          ];
        };

      toolingPkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkSystem;

      devShells.${system}.default = toolingPkgs.mkShell {
        buildInputs = with toolingPkgs; [
          nix
          nixd
          nixfmt-rfc-style
        ];
      };

      # Formatter for .nix files. Run using "nix fmt" command.
      formatter.${system} = toolingPkgs.nixfmt-tree;
    };
}
