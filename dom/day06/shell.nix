let pkgs = import <nixpkgs> { };
in pkgs.mkShell {
  name = "Day_6";
  nativeBuildInputs = with pkgs.buildPackages; [
    just
    neovim
    lazygit
    ocaml
    ocamlPackages.utop
    ocamlPackages.ocamlformat
    ocamlPackages.ocaml-lsp
    opam
    statix
  ];
  shellHook = ''
    eval $(opam env --switch=default)
    echo ""
    echo "Advent of Code 2025"
    echo "Day 6 - Trash Compactor - https://adventofcode.com/2025/day/6"
    echo ""
  '';
}
