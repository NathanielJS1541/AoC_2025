# Nat's AoC 2025 Day 03 Solution

My solution to the [Advent of Code Day 03](https://adventofcode.com/2025/day/3)
is written in [pwsh](https://github.com/PowerShell/PowerShell), and expects the
input data to be passed in as a text file using command line arguments. See
[usage](#usage) for more details.

## Usage

This script requires:
 - [`pwsh`](https://github.com/PowerShell/PowerShell) to be installed on the
   system.
 - Your challenge input to be downloaded locally.

The script can accept the input data as an argument, providing the path to the
file:

```pwsh
.\Measure-MaxJoltage.ps1 -InputPath .\input
```

Or as a pipeline input:

```pwsh
Get-Content input | .\Measure-MaxJoltage.ps1
```

For more usage information, use `Get-Help`:

```pwsh
Get-Help .\Measure-MaxJoltage.ps1 -Detailed


NAME
    .\Measure-MaxJoltage.ps1

SYNOPSIS
    Solution to day 03 of the Advent of Code 2025 implemented in pwsh.


SYNTAX
    .\Measure-MaxJoltage.ps1 -InputPath <String> [<CommonParameters>]

    .\Measure-MaxJoltage.ps1 [-InputObject <String>] [<CommonParameters>]


DESCRIPTION
    Parses information about a series of battery banks from the specified input
    file or pipeline data and calculates the maximum achievable joltage under
    different constraints.

PARAMETERS
    -InputPath <String>
        Path to the input file to process. This can either be the test input or the
        full day 03 input file.

    -InputObject <String>
        When using the "Pipeline" parameter set, lines of input can be provided
        via the pipeline.

    -------------------------- EXAMPLE 1 --------------------------

    PS > .\Measure-MaxJoltage.ps1 -InputPath .\input

    Use the script to parse the battery bank information from the "input" file,
    and output the maximum achievable joltages.

    -------------------------- EXAMPLE 2 --------------------------

    PS > Get-Content input | .\Measure-MaxJoltage.ps1

    Use the script to parse the battery bank information from the contents of
    the "input" file, and output the maximum achievable joltages.
```
