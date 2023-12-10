{
  description = "PHYLIP";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        phylip-drv = pkgs.stdenv.mkDerivation
          {
            name = "phylip";
            version = "3.697";
            src = pkgs.fetchzip {
              url = "https://phylipweb.github.io/phylip/download/phylip-3.697.tar.gz";
              hash = "sha256-u6M3VyBNRKPRDuqz9dzsNkaYbsdqWgioThK2lWiL6Vg=";
            };

            # a fix for some problem in the code connected with double importing the same .h file and absence of "extern" keyword
            NIX_CFLAGS_COMPILE = "-O3 -DUNX -fomit-frame-pointer -fcommon";

            buildInputs = [
              pkgs.gcc
            ];

            buildPhase = ''
              cd src
              make -f Makefile.unx install
            '';

            installPhase = ''
              mkdir -p $out/bin
              cp -r ../exe/* $out/bin
            '';

          };
      in
      rec
      {

        packages.default = phylip-drv;

      });
}
