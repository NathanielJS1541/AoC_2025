#!/usr/bin/env bash
#
# Solutions to Day 01 of the Advent of Code 2025 challenge written in bash.
#
# Author: Nathaniel Struselis
# SPDX-License-Identifier: AGPL-3.0-only

# Constants representing error codes.
ERR_OK=0    # OK status - no error.
ERR_USAGE=1 # Incorrect usage or arguments.
ERR_FILE=2  # File not found error.
ERR_INPUT=3 # Input file processing error.

# Create a USAGE variable containing the usage message for this script.
read -d '' -r USAGE <<- EOF
Usage: day01.sh -i ./input.txt

Read challenge input data from a text file and calculate the solutions.

Options
    -h            Print this message and exit.
    -i <input>    [REQUIRED] Path to the challenge input file.
EOF

# Function to solve the day 01 challenge using the supplied input, and write the
# results for part 1 and 2 to an array passed in by name.
#
# The solutions array passed by name will be updated to contain two elements:
# - [0]: The solution to part 1.
# - [1]: The solution to part 2.
#
# Arguments:
# - $1: The name of the array variable containing the input data.
# - $2: The name of the array variable to write the solutions to.
#
# Usage:
#   solve_day01 <input_array_name> <solutions_array_name>
solve_day01() {
    # Declare a nameref variable to the array to pass the results back to the
    # caller.
    local -n results=$2

    # Dummy solutions to test script structure.
    results=("TODO" "TODO")
}

# Main function to parse arguments and execute the script logic.
main() {
    # Declare a local variable to store the required input file path.
    local input

    # Declare variables for the getopts built-in:
    # - OPTIND: Index of the next argument to be processed.
    # - OPTARG: Argument value for the current option.
    # - opt: Current option letter being processed.
    local OPTIND OPTARG opt

    # Parse command-line options using getopts:
    # - ":": Enable silent mode for custom error messages.
    # - "i:": Input file option, ":" = requires an argument.
    # - "h": Help option, does not take arguments.
    while getopts ':i:h' opt; do
        # Case statement to handle each option.
        case "$opt" in
            # Input file option; store the path in the input variable.
            i) input=$OPTARG;;
            # Help option; print usage message and exit with the success code.
            h) echo "$USAGE"; exit $ERR_OK;;
            # Missing argument for option; print error message and exit with an
            # error code.
            :)
                echo "Error: Option -$OPTARG requires an argument." >&2
                exit $ERR_USAGE;;
            # Default case; option not matched. Print usage message and exit
            # with error.
            *) echo "$USAGE" >&2; exit $ERR_USAGE;;
        esac
    done

    # Check if the required input file path was provided.
    if [[ -z "$input" ]]; then
        # Print a specific error message to stderr.
        echo "Error: Option -i <input> is required." >&2
        # Print a blank line to stderr for readability.
        echo >&2
        # Print usage message to stderr.
        echo "$USAGE" >&2
        # Exit with an error code.
        exit $ERR_USAGE
    fi

    # Check that a file exists at the specified input file path.
    if [[ ! -f "$input" ]]; then
        # Print an error message to stderr and exit with an error code.
        echo "Error: File $input not found." >&2
        exit $ERR_FILE
    fi

    # TODO: Open the file at $input?
    # I don't yet know the structure of the data or how I want to process it,
    # so I'm leaving this part as a placeholder for now.
    #
    # Perhaps the processing methods will need to do this themselves if they
    # require different structures.
    #mapfile -t input_data < "$input"
    # or
    #input_data=$(< "$input")
    # TODO: Dummy placeholder for input processing.
    local input_data

    # TODO: Use $ERR_INPUT return code for input processing errors.

    # Declare an array to hold the solutions for each part of the challenge.
    declare -a solutions

    # Pass the input data and solutions arrays by name to the function to solve
    # the day 01 challenge.
    solve_day01 input_data solutions

    # Print the solutions to stdout.
    echo "AoC 2025 Day 01 Solutions:"
    echo "Part 1: ${solutions[0]}"
    echo "Part 2: ${solutions[1]}"
}

# Invoke main script logic with all positional arguments.
main "$@"
