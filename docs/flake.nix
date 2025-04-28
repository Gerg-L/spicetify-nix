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
    spicetify-nix.url = "../.";
  };
  outputs =
    {
      self,
      nixpkgs,
      systems,
      spicetify-nix,
    }:
    let
      inherit (nixpkgs) lib;
      eachSystem = lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.nixosOptionsDoc {
          #warningsAreErrors = false;
          inherit
            (
              (lib.evalModules {
                specialArgs = { inherit pkgs; };
                modules = [
                  (import ../modules/options.nix spicetify-nix)
                  ../modules/linuxOpts.nix
                ];
              })
            )
            options
            ;
        }
        // {
          default = pkgs.callPackage ./package.nix {
            inherit (self.packages.${pkgs.stdenv.system}) optionsJSON;
          };
        }
      );

      devShells = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            # use npm run dev
            packages = [
              pkgs.nodejs
            ];
            env.SPICETIFY_OPTIONS_JSON = self.packages.${system}.optionsJSON;
          };
        }
      );
    };
}
