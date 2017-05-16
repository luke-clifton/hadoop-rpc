{ hadoop-rpc-src ? ./.
, systems ? [builtins.currentSystem]
}:

let
  pkgs = import <nixpkgs> {};
  name = "hadoop-rpc";

  # Compilers to use.
  compilers = [
    "ghc802"
    "ghc7103"
  ];

  jobs = rec {
    build = pkgs.lib.genAttrs systems (system:
      pkgs.lib.genAttrs compilers (compiler:
        with import <nixpkgs> {inherit system;};
        haskell.lib.buildFromSdist (
          haskell.lib.dontCheck (haskell.packages.${compiler}.callCabal2nix name hadoop-rpc-src {})
        )
      )
    );
  };

in jobs
