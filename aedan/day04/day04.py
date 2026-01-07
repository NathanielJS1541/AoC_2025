from pathlib import Path
import sys


def GetAdjacentPositions(pos: tuple[int, int], max_row: int, max_col: int):
    x, y = pos
    rows = [x]
    cols = [y]
    positions = []
    if x != 0:
        cols.append(x - 1)
    if x != max_col - 1:
        cols.append(x + 1)
    if y != 0:
        rows.append(y - 1)
    if x != max_row - 1:
        rows.append(y + 1)
    for row in rows:
        for col in cols:
            if (col, row) != pos:
                positions.append((col, row))
    return positions


def Main(p: Path) -> None:
    grid = p.read_text().splitlines()
    for row_idx, row in enumerate(grid):
        for col_idx, col in enumerate(row):
            adjacents = GetAdjacentPositions((col_idx, row_idx), len(grid), len(row))
            print((col, row), adjacents)


if __name__ == "__main__":
    Main(Path(sys.argv[1]))
