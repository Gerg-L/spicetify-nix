{
  pkgs ? import <nixpkgs> { },
}:
pkgs.lib.fix (
  self:
  {
    packages = import ./pkgs { inherit pkgs self; };
    lib = import ./lib {
      inherit self;
      inherit (pkgs) lib;
    };
  }
  // import ./modules self
)
