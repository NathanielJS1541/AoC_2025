"""Day 2 of Advent of Code."""

import sys
from pathlib import Path


def CheckValid(s: str, pt2: bool) -> bool:
    """Check if a number is valid."""
    seq: str = s[0]
    while len(seq) < len(s):
        if seq == s[len(seq) :] or (pt2 and s.count(seq) * len(seq) == len(s)):
            return False
        seq = s[: len(seq) + 1]
    return True


def Main(path: Path) -> None:
    """Find the invalid numbers in keystr."""
    ranges: list[str] = path.read_text().split(",")
    invalid_sum_1: int = 0
    invalid_sum_2: int = 0
    for r in ranges:
        start, end = r.split("-")
        for idx in range(int(start), int(end) + 1):
            if not CheckValid(str(idx), pt2=False):
                invalid_sum_1 += idx
            if not CheckValid(str(idx), pt2=True):
                invalid_sum_2 += idx
    print("Part 1: ", invalid_sum_1)
    print("Part 2: ", invalid_sum_2)


if __name__ == "__main__":
    Main(Path(sys.argv[1]))
