{
  pkgs,
  username,
  stateVersion,
  ...
}: {
  imports = [./spicetify.nix];

  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
  };

  # list where you can specify unfree packages to allow
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify-unwrapped"
    ];

  home.packages = with pkgs; [
    # put packages you want to install here
  ];
}
