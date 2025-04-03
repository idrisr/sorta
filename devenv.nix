{ pkgs, ... }:
let compiler = "ghc96";
in {
  packages = with pkgs.haskell.packages."${compiler}"; [
    cabal2nix
    cabal-fmt
    fourmolu
    ghcid
    graphmod
    implicit-hie
    pkgs.xdot
  ];

  languages.haskell.enable = true;

  scripts.modgraph.exec = ''
    find sorta/app sorta/src -name "*.hs" | xargs graphmod -q  | dot -Tpdf -o modgraph.pdf
  '';
}
