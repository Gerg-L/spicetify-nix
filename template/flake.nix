{
  description = "My home-manager configuration";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs?ref=nixos-22.11;
    spicetify-nix.url = github:the-argus/spicetify-nix;
    home-manager = {
      url = github:nix-community/home-manager/release-22.11;
      # home manager use our nixpkgs and not its own
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    spicetify-nix,
  } @ inputs: let
    username = "unknown";

    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    genSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgs = genSystems (system: import nixpkgs {inherit system;});

    # not these though
    stateVersion = "22.11";
  in {
    packages = genSystems (system: {
      ${system}.homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration rec {
        pkgs = pkgs.${system};
        modules = [./home.nix];
        extraSpecialArgs =
          inputs
          // {
            inherit username stateVersion;
          };
      };
    });
  };
}
