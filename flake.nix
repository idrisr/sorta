{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          compiler = "ghc984";
          sorta = pkgs.haskell.packages.${compiler}.callPackage ./sorta { };
        in
        { packages.default = sorta; }
      )
    //
    {
      overlays.default = final: prev: {
        mksession =
          final.haskell.packages.ghc984.callPackage ./sorta.nix { };
      };
    }
  ;
}
