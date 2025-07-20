{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
      mkSystem =
        hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };

          modules = [
            home-manager.nixosModules.default
            ./configuration.nix
            ./host/${hostname}/configuration.nix
            ./host/${hostname}/hardware-configuration.nix
          ];
        };

      toolingSystem = "x86_64-linux";
      toolingPkgs = nixpkgs.legacyPackages.${toolingSystem};
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkSystem;

      devShells.${toolingSystem}.default = toolingPkgs.mkShell {
        buildInputs = with toolingPkgs; [
          nix
          nixd
          nixfmt-rfc-style
        ];
      };

      # Formatter for .nix files. Run using "nix fmt" command.
      formatter.${toolingSystem} = toolingPkgs.nixfmt-tree;
    };
}
