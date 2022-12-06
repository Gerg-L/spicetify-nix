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
    nixpkgs,
    home-manager,
    spicetify-nix,
  } @ inputs: let
    # you can change these two variables to suit your system
    username = "unknown";
    system = "x86_64-linux";

    # not these though
    stateVersion = "22.11";
    pkgs = import nixpkgs {localSystem = {inherit system;};};
  in {
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration rec {
      inherit pkgs;
      modules = [./home.nix];
      extraSpecialArgs =
        inputs
        // {
          inherit username stateVersion;
        };
    };
  };
}
