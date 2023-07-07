{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, flake-utils, nixpkgs }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlay = self: super: {
          ocamlPackages = super.ocamlPackages.overrideScope' (oself: osuper: {
            ancient = oself.buildDunePackage {
              pname = "ancient";
              version = "0.1";
              useDune3 = true;
              src = ./.;
            };
          });
        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
      in {
        overlay = overlay;
        defaultPackage = pkgs.ocamlPackages.ancient;
        devShell = pkgs.mkShell {
          nativeBuildInputs =
            [ pkgs.ocamlformat pkgs.opam pkgs.ocamlPackages.ocaml-lsp ];
          inputsFrom = [ self.defaultPackage.${system} ];
        };
      });
}
