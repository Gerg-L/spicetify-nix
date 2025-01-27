{
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    systems = {
      type = "github";
      owner = "nix-systems";
      repo = "default";
    };
    flake-compat = {
      type = "github";
      owner = "edolstra";
      repo = "flake-compat";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      ...
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      homeManagerModules = {
        spicetify = import ./module.nix {
          inherit self;
          isNixOSModule = false;
        };
        default = self.homeManagerModules.spicetify;
      };

      nixosModules = {
        spicetify = import ./module.nix {
          inherit self;
          isNixOSModule = true;
        };
        default = self.nixosModules.spicetify;
      };

      darwinModules = {
        spicetify = import ./module.nix {
          inherit self;
          isNixOSModule = true;
        };
        default = self.darwinModules.spicetify;
      };

      legacyPackages = eachSystem (
        system:
        import ./pkgs {
          inherit self;
          pkgs = nixpkgs.legacyPackages.${system};
        }
      );

      formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      devShells = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShellNoCC { packages = [ pkgs.npins ]; };
          fetcher = pkgs.mkShell {
            packages = builtins.attrValues { inherit (pkgs) rust-analyzer clippy rustfmt; };
            inputsFrom = [ self.legacyPackages.${system}.fetcher ];
          };
        }
      );
    };
}
