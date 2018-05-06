{ nixpkgs ? import <nixpkgs> {}
}:
let
  inherit (nixpkgs) pkgs;

  revealjs = pkgs.fetchgit {
    url = "https://github.com/hakimel/reveal.js.git";
    rev = "65bdccd5807b6dfecad6eb3ea38872436d291e81";
    sha256 = "07460ij4v7l2j0agqd2dsg28gv18bf320rikcbj4pb54k5pr1218";
  };

  local = ./.;
in
  pkgs.stdenv.mkDerivation {
    name = "state-machine-testing";
    src = ./.;

    unpackPhase = ''
      mkdir -p $name/{reveal.js,css,images,js}
      cd $name
      cp -r ${revealjs}/* ./reveal.js/
      cp $src/css/* ./css/
      # rm ./css/grid-light.css
      cp $src/images/* ./images/
    '';

    buildPhase = ''
      cat $src/slides/title.md \
          $src/slides/intro.md \
          $src/slides/property-based-testing.md \
          $src/slides/state-machines.md \
          > slides.md
      pandoc -i -t revealjs --slide-level=2 --template=$src/template.revealjs --variable=codedir:$out --variable=transition:none --no-highlight -s slides.md -o index.html
      rm slides.md
    '';

    installPhase = ''
      mkdir $out
      cp -r ./* $out/
    '';

    phases = ["unpackPhase" "buildPhase" "installPhase"];

    buildInputs = [pkgs.pandoc];
  }
