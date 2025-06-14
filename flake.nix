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
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # The only system configuration.
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          home-manager.nixosModules.default
          ./configuration.nix
          ./host/configuration.nix
        ];
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nix
          nixd
          nixfmt-rfc-style
        ];
      };

      # Formatter for .nix files. Run using "nix fmt" command.
      formatter.${system} = pkgs.nixfmt-tree;
    };
}
