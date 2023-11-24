pkgs:
let
  source = import ../npins;
in
{
  themes = pkgs.callPackage ./themes.nix { inherit source; };
  apps = pkgs.callPackage ./apps.nix { inherit source; };
  extensions = pkgs.callPackage ./extensions.nix { inherit source; };
}
