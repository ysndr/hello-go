{
  description = "hello-go package";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.capacitor.url = "github:flox/capacitor";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, capacitor, flake-utils,... } @ args:

    let
      version = builtins.substring 0 8 self.lastModifiedDate;
      flake = flake-utils.lib.eachDefaultSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in
        with pkgs;
        rec {
          packages = flake-utils.lib.flattenTree {
            hello-go = buildGoModule rec {
              pname = "hello-go";
              inherit version;
              # In 'nix develop', we don't need a copy of the source tree
              # in the Nix store.
              src = ./.;

              # This hash locks the dependencies of this package. It is
              # necessary because of how Go requires network access to resolve
              # VCS.  See https://www.tweag.io/blog/2021-03-04-gomod2nix/ for
              # details. Normally one can build with a fake sha256 and rely on native Go
              # mechanisms to tell you what the hash should be or determine what
              # it should be "out-of-band" with other tooling (eg. gomod2nix).
              # To begin with it is recommended to set this, but one must
              # remeber to bump this hash when your dependencies change.
              #vendorSha256 = pkgs.lib.fakeSha256;

              vendorSha256 = "sha256-hnLItaDj5nVedbkpbPUw/A/7Iu2q1VwlYWzhvshWThk=";
            };
          };
          defaultPackage = packages.hello-go;
        }
      );
    in
    capacitor.lib.capacitate args inputs ( _: flake);
}
