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
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      eachSystem = f: lib.genAttrs (import systems) (s: f nixpkgs.legacyPackages.${s});
    in
    {
      lib = import ./lib { inherit lib self; };

      legacyPackages = eachSystem (
        pkgs:
        import ./pkgs {
          inherit pkgs self;
          unfreePkgs = import nixpkgs {
            inherit (pkgs.stdenv) system;
            config.allowUnfreePredicate = pkg: (lib.getName pkg == "spotify");
          };
        }
      );

      formatter = eachSystem (pkgs: pkgs.nixfmt-rfc-style);

      devShells = eachSystem (pkgs: {
        default = pkgs.mkShellNoCC { packages = [ pkgs.npins ]; };
        fetcher = pkgs.mkShell {
          packages = builtins.attrValues { inherit (pkgs) rust-analyzer clippy rustfmt; };
          inputsFrom = [ self.legacyPackages.${pkgs.stdenv.system}.fetcher ];
        };
        docs = pkgs.mkShellNoCC {
          # use npm run dev
          packages = [
            pkgs.nodejs
          ];
          env.SPICETIFY_OPTIONS_JSON = self.legacyPackages.${pkgs.stdenv.system}.docs.optionsJSON;
        };
      });
    }
    // import ./modules self;
}
