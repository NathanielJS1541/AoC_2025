# Nat's AoC 2025 Day 04 Solution

My solution to the [Advent of Code Day 04](https://adventofcode.com/2025/day/4)
is written in [lua](https://www.lua.org/), and expects the input data to be
passed in as a text file using command line arguments. See [usage](#usage) for
more details.

## Usage

This script requires:

- [`lua`](https://www.lua.org/) or [`luajit`](https://luajit.org/) to be
  installed on your system.
- Your challenge input to be downloaded locally.

In this script, I've intentionally avoided the use of attributes like `<const>`
so it is compatible with both `lua` (including older versions) and `luajit`.
Either can be used to run this script:

```bash
lua day04.lua -i ./input
```

or:

```bash
luajit day04.lua -i ./input
```

For more usage information, use `lua day04.lua --help`:

```text
Usage: lua day04.lua -i ./input

Read challenge input data from a text file and calculate the solutions to Day 04
of the Advent of Code challenge.

Options
    -h or --help                  Print this message and exit.
    -i or --input <input_path>    [REQUIRED] Path to the challenge input file.
```
