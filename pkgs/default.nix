pkgs:
let
  source = import ../npins;
in
{
  spicetify = pkgs.callPackage ./spicetify.nix {};
  themes = pkgs.callPackage ./themes.nix {inherit source;};
  apps = pkgs.callPackage ./apps.nix {inherit source;};
  extensions = pkgs.callPackage ./extensions.nix {inherit source;};
}
