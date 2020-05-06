{ pkgs, lib }:

let sources = import ../../nix/sources.nix;
    cargoNix = pkgs.callPackage ./generated/Cargo.nix {};
in
{
  source = sources.nix-test-runner;
  package = cargoNix.workspaceMembers.nix-test-runner.build.overrideAttrs (attrs: {
    meta = {
        description = "Nix build file generator for rust crates.";
        longDescription = ''
          Crate2nix generates nix files from Cargo.toml/lock files
          so that you can build every crate individually in a nix sandbox.
        '';
        homepage = https://github.com/kolloch/crate2nix;
        license = lib.licenses.asl20;
        maintainers = [
          {
            github = "stoeffel";
            githubId = 1217681;
            name = "Christoph Hermann";
          }
          # TODO: Change to lib.maintainers.kolloch
          # after https://github.com/NixOS/nixpkgs/pull/86642
          {
            github = "kolloch";
            githubId = 339354;
            name = "Peter Kolloch";
            email = "info@eigenvalue.net";
          }
        ];
        platforms = lib.platforms.all;
      };
  });
}
