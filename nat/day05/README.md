# Nat's AoC 2025 Day 05 Solution

My solution to the [Advent of Code Day 05](https://adventofcode.com/2025/day/5)
is written in [Nushell](https://www.nushell.sh/), and expects the input data to
be passed in as a text file using command line arguments. See [usage](#usage)
for more details.

## Usage

This script requires:

- [Nushell](https://www.nushell.sh/) to be installed on your system.
- Your challenge input to be downloaded locally.

You can run the script as follows:

```bash
nu day05.nu ./input
```

For more usage information, use `nu day05.nu --help`:

```text
Calculate the number of fresh ingredients, and the total number of unique
fresh ingredient IDs in the provided input file.

Returns a record containing two fields:
- fresh_ingredients: The number of ingredient IDs that fall within the "fresh"
  id ranges.
- total_fresh_ids: The total number of unique ingredient IDs that fall within
  any of the fresh ID ranges.

Usage:
  > day05.nu <input_path>

Flags:
  -h, --help: Display the help message for this command

Parameters:
  input_path <path>: Path to the challenge input file.

Input/output types:
  ╭───┬─────────┬──────────────────────────────────────────────────────╮
  │ # │  input  │                        output                        │
  ├───┼─────────┼──────────────────────────────────────────────────────┤
  │ 0 │ nothing │ record<fresh_ingredients: int, total_fresh_ids: int> │
  ╰───┴─────────┴──────────────────────────────────────────────────────╯
```
