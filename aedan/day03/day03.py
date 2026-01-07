"""Day 03."""

from pathlib import Path
import sys
from itertools import combinations
from tqdm import tqdm

MAX_BATTERIES_PT2 = 12


def Main(p: Path) -> None:
    """Day 03."""
    pt1_sum = 0
    pt2_sum = 0
    for line in p.read_text().splitlines():
        pt1_numbers = []
        pt2_numbers = []
        for start in line:
            pt1_numbers.extend([int(start + x) for x in line[line.index(start) + 1 :]])
        pt1_sum += max(pt1_numbers)

        """value: int = 1
        new_number: str = line
        while len(new_number) > MAX_BATTERIES_PT2:
            for i in range(new_number.count(str(value))):
                print(i, value, new_number)
                new_number = new_number.replace(str(value), "", 1)
                if len(new_number) == MAX_BATTERIES_PT2:
                    break
            value += 1
            if value > 9:
                break
        print(new_number)
        pt2_sum += int(new_number)"""

        for comb in tqdm(combinations(range(len(line)), len(line) - 12)):
            val = ""
            for idx, l in enumerate(line):
                if idx not in comb:
                    val += l
            pt2_numbers.append(int(val))
        print(max(pt2_numbers))
        pt2_sum += max(pt2_numbers)

    print(f"Part 1: {pt1_sum}")
    print(f"Part 2: {pt2_sum}")


if __name__ == "__main__":
    p = Path(sys.argv[1])
    Main(p)
