let pkgs = import <nixpkgs> { };
in pkgs.mkShell {
  name = "Day_6";
  nativeBuildInputs = with pkgs.buildPackages; [
    just
    neovim
    lazygit
    ocaml
    ocamlPackages.utop
    statix
  ];
  shellHook = ''
    echo ""
    echo "Advent of Code 2025"
    echo "Day 6 - Trash Compactor - https://adventofcode.com/2025/day/6"
    echo ""
  '';
}
