{
  pkgs,
  lib,
  username,
  stateVersion,
  ...
}: {
  imports = [./spicetify.nix];

  # assume you're not using nixOS
  targets.genericLinux.enable = true;

  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
  };

  # list where you can specify unfree packages to allow
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify-unwrapped"
      "spotify"
    ];

  home.packages = with pkgs; [
    # put packages you want to install here
  ];
}
