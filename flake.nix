{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells = {
          default = pkgs.mkShell {
            packages =
            let
              watchWithGhcid = pkgs.writers.writeDashBin "watch" ''
                ${pkgs.ghcid}/bin/ghcid --command="cabal repl"
              '';
              # Wrap cabal to always run `hpack` first.
              cabalWrapped = pkgs.writers.writeDashBin "cabal" ''
                ${pkgs.hpack}/bin/hpack
                ${pkgs.cabal-install}/bin/cabal "$@"
              '';
            in with pkgs; [
              cabalWrapped
              hpack
              ghcid
              watchWithGhcid

              (ghc.withPackages (ps: with ps; [
                miso
              ]))
            ];
          };
        };
      }
    );
}
