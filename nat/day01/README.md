# Nat's AoC 2025 Day 01 Solution

My solution to the [Advent of Code Day 01](https://adventofcode.com/2025/day/1)
is written in [bash](https://www.gnu.org/software/bash/), and expects the input
data to be passed in as a text file using command line arguments. See
[usage](#usage) for more details.

## Usage

This script requires:

- `bash 4.3+` to be installed on the system. This script uses variables with
  the `nameref` attribute, which were introduced in `bash 4.3`.
- Your challenge input to be downloaded locally.
- The script to be executable.

Simply run the following to make the script executable:

```sh
chmod +x day01.sh
```

The script accepts a single required argument indicated by the `-i` option; the
path to the input data. The `-h` flag can be provided to view the usage
information:

```
Usage: day01.sh -i ./input

Read challenge input data from a text file and calculate the solutions.

Options
    -h            Print this message and exit.
    -i <input>    [REQUIRED] Path to the challenge input file.
```

Simply pass the path to your downloaded challenge input file in the `-i` option,
and the script will calculate the solutions to both parts of the challenge.
