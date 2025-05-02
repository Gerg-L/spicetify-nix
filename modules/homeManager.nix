{
  lib,
  config,
  pkgs,
  ...
}:
{
  home = {
    packages = lib.mkIf config.programs.spicetify.enable config.programs.spicetify.createdPackages;
    activation = lib.mkIf pkgs.stdenv.isDarwin {
      disableSpotifyUpdate =
        let
          updateDir = "${config.home.homeDirectory}/Library/Application Support/Spotify/PersistentCache/Update";
        in
        ''
          run mkdir -p '${updateDir}' || echo "spicetify-nix: Failed to disable spotify updates"
          run chflags -R uchg '${updateDir}' || echo "spicetify-nix: Failed to disable spotify updates"
        '';
    };
  };

}
