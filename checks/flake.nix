{
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    nix-darwin = {
      type = "github";
      owner = "nix-darwin";
      repo = "nix-darwin";
    };
    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
    };
    spicetify-nix.url = "../.";
  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      spicetify-nix,
      home-manager,
      ...
    }:
    # use nix flake check --no-build
    {
      checks.x86_64-linux =
        let
          spicePkgs = spicetify-nix.legacyPackages.x86_64-linux;
          opts = {
            enabledExtensions = builtins.attrValues {
              inherit (spicePkgs.extensions)
                adblockify
                hidePodcasts
                shuffle
                ;
            };
            theme = spicePkgs.themes.catppuccin;
            colorScheme = "mocha";
          };
          module = {
            programs.spicetify = opts;
          };
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };

        in
        {
          standalone = spicetify-nix.lib.mkSpicetify pkgs opts;

          home-manager =
            (home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                spicetify-nix.homeManagerModules.default
                {
                  home = {
                    username = "x";
                    homeDirectory = "/home/x";
                    stateVersion = "24.11";
                  };
                }
                module
              ];
            }).activationPackage;
          darwin =
            (nix-darwin.lib.darwinSystem {
              modules = [
                spicetify-nix.darwinModules.default
                {
                  nixpkgs = {
                    inherit pkgs;
                  };

                  system = {
                    configurationRevision = self.rev or self.dirtyRev or null;
                    stateVersion = 6;
                  };
                  # This might cause weird errors
                  nixpkgs.hostPlatform = "x86_64-linux";
                }
                # also this
                module
              ];
            }).config.system.build.toplevel;

          nixos =
            (nixpkgs.lib.nixosSystem {
              modules = [
                spicetify-nix.nixosModules.default
                {
                  nixpkgs = {
                    inherit pkgs;
                  };

                  nixpkgs.hostPlatform = "x86_64-linux";
                  boot.loader.grub.enable = false;
                  fileSystems."/".device = "nodev";
                  system.stateVersion = nixpkgs.lib.trivial.release;
                }
                module
              ];
            }).config.system.build.toplevel;

        };
    };
}
