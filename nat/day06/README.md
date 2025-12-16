# Nat's AoC 2025 Day 06 Solution

My solution to the [Advent of Code Day 06](https://adventofcode.com/2025/day/6)
is written in [wren](https://github.com/wren-lang/wren), and expects the input
data to be passed in as a text file using command line arguments. See
[usage](#usage) for more details.

## Usage

This script requires:

- [`wren_cli`](https://github.com/wren-lang/wren-cli) to be installed on your
  system.
- Your challenge input to be downloaded locally.

This script only uses core modules and the modules provided by `wren_cli`, so no
external modules are required to run it.

You can run the script as follows:

```bash
wren_cli day06.wren --input ./input
```

For more usage information, use `wren_cli day06.wren --help`:

```text
Usage: wren_cli day06.wren -i ./input

Read challenge input data from a text file and calculate the solutions to Day 06
of the Advent of Code challenge.

Options:
    -h or --help                  Print this message and exit.
    -i or --input <input_path>    [REQUIRED] Path to the challenge input file.
```
