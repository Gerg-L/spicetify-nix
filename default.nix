{
  pkgs ? import <nixpkgs> { },
}:
{
  lib = import ./lib pkgs.lib;
  packages = import ./pkgs { inherit pkgs; };
}
// import ./modules pkgs.lib
