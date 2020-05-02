{ pkgs, lib, nixTestRunner }:

rec {
  # I use this to keep individual features also importable independently
  # of other code in this NUR repo.
  inherit (pkgs.callPackage ./rerun-fixed.nix {}) rerunFixedDerivationOnChange;

  runTests = nixTestRunner.runTests;
}

