{ pkgs, lib }:

let sources = import ../../nix/sources.nix;
    cargoNix = pkgs.callPackage ./generated/Cargo.nix {};
in
{
  source = "${sources.crate2nix}/crate2nix";
  package = cargoNix.workspaceMembers.crate2nix.build.overrideAttrs (attrs: {
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
          github = "kolloch";
          githubId = 339354;
          name = "Peter Kolloch";
        }
        lib.maintainers.andir
      ];
      platforms = lib.platforms.all;
    };
  });
}
