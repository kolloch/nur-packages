# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ sources ? import ./nix/sources.nix
, nixpkgs ? sources.nixpkgs
, pkgs ? import nixpkgs {}
, nixTestRunnerSrc ? sources.nix-test-runner
, nixTestRunner ? pkgs.callPackage nixTestRunnerSrc {}
}:

rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = pkgs.callPackage ./lib { inherit nixTestRunner; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  tests = pkgs.lib.callPackageWith
    (pkgs // { inherit sources; nurKollochLib = lib; } )
    ./tests {};

  nix-test-runner = nixTestRunner.package;

  # Packages.
  # example-package = pkgs.callPackage ./pkgs/example-package { };
  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}

