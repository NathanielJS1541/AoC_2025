# Nat's AoC 2025 Day 02 Solution

My solution to the [Advent of Code Day 02](https://adventofcode.com/2025/day/2)
is written in [Perl](https://www.perl.org/), and expects the input data to be
passed in as a text file using command line arguments. See [usage](#usage) for
more details.

## Usage

This script requires:

- [`Perl`](https://www.perl.org/) to be installed on the system.
- Your challenge input to be downloaded locally.

This script has no external dependencies, as it only uses core modules.

The script can be run as follows:

```sh
perl ./day02.pl --input ./input
```

Or simply:

```sh
./day02.pl --input ./input
```

If the script is executable.

The script accepts a single required argument indicated by the `--input` or `-i`
option; the path to the input data file. The `--help` or `-h` flag can be
provided to view the usage information:

```text
Usage:
    day02.pl [options] --input <file_path>

Options:
    --help or -h
      Print the script's usage information, and exit.

    --input <file_path> or -i <file_path>
      Required. Specifies the input file to process.

    --man or -m
      Print the script's man page, and exit.
```
