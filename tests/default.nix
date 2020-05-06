{ pkgs, stdenv, lib, nurKollochLib }:

rec {
  # Causes ci.nix to recurse into the tests.
  # Disabled because NUR does not like import from derivation.
  recurseForDerivations = true;

  myFixedOutputDerivation =
    pkgs.runCommand
      "download-something"
      {
        buildInputs = [ pkgs.curl pkgs.cacert ];
        outputHash = "sha256:1w9k15dvbawnwn8mqi6v8panf8s7g3p6iaydmkdp87fd7vgxkc14";
        outputHashMode = "recursive";
      }
      ''
      # This is just a test, obviously, we would use a fetcher for this.
      curl -o $out https://static.crates.io/crates/nix-base32/nix-base32-0.1.1.crate
      '';

  myChangedFixedOutputDerivation =
    pkgs.runCommand
      "download-something"
      {
        buildInputs = [ pkgs.curl pkgs.cacert ];
        outputHash = "sha256:1w9k15dvbawnwn8mqi6v8panf8s7g3p6iaydmkdp87fd7vgxkc14";
        outputHashMode = "recursive";
      }
      ''
      # TOTALLY DIFFERENT
      curl -o $out https://static.crates.io/crates/nix-base32/nix-base32-0.1.1.crate
      '';


  myOverriddenFixedOutputDerivation = myFixedOutputDerivation.overrideAttrs (attrs: {
      anotherAttribute = "overridden";
    });

  rerunOnChange_myFixedOutputDerivation =
    nurKollochLib.rerunFixedDerivationOnChange myFixedOutputDerivation;

  rerunOnChange_myChangedFixedOutputDerivation =
    nurKollochLib.rerunFixedDerivationOnChange myChangedFixedOutputDerivation;

  overridden_rerunOnChange_myFixedOutputDerivation =
    rerunOnChange_myFixedOutputDerivation.overrideAttrs (attrs: { something = "change"; });

  rerunFixedDerivationOnChangeTests = nurKollochLib.runTests {
    name = "rerunFixedDerivationOnChange";
    tests = {
      testChangedFixedOutputDerivation = {
        expr = "${myFixedOutputDerivation}";
        expected = "${myChangedFixedOutputDerivation}";
      };
      testOverriddenFixedOutputDerivation = {
        expr = "${myFixedOutputDerivation}";
        expected = "${myOverriddenFixedOutputDerivation}";
      };

      testInstrumentedFixedOutputDerivation = {
        expr =
          if "${rerunOnChange_myFixedOutputDerivation}" != "${rerunOnChange_myChangedFixedOutputDerivation}"
          then ""
          else "both paths are the same: ${rerunOnChange_myFixedOutputDerivation}";
        expected = "";
      };
      testOverrideResultsInChange = {
        expr =
          if "${rerunOnChange_myFixedOutputDerivation}" != "${overridden_rerunOnChange_myFixedOutputDerivation}"
          then ""
          else "both paths are the same: ${rerunOnChange_myFixedOutputDerivation}";
        expected = "";
      };
    };
  };
}