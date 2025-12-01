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
# - [0]: The number of times the dial lands on 0.
# - [1]: The solution to part 2.
#
# Arguments:
# - $1: The name of the array variable containing the input data.
# - $2: The name of the array variable to write the solutions to.
#
# Usage:
#   solve_day01 <input_array_name> <solutions_array_name>
solve_day01() {
    # Declare a nameref variable to the input array variable to access the input
    # data.
    local -n input=$1

    # Declare a nameref variable to the array to pass the results back to the
    # caller.
    local -n results=$2

    # Local variable to count the number of times the dial lands on 0.
    local zero_landings=0

    # The dial starts pointing at position 50.
    local dial_position=50

    # Loop through each rotation in the input data and process it.
    local rotation direction distance
    for rotation in "${input[@]}"; do
        # Parse each input line into direction and distance components.
        #
        # Each line should be in the format "L<distance>" or "R<distance>".
        if [[ "$rotation" =~ ^([LR])([0-9]+)$ ]]; then
            direction=${BASH_REMATCH[1]}
            distance=${BASH_REMATCH[2]}

            # Update the dial position based on the direction and distance.
            # Right moves the dial in the positive direction, left moves the
            # dial in the negative direction.
            case "$direction" in
                R) dial_position=$(( dial_position + distance ));;
                L) dial_position=$(( dial_position - distance ));;
                *)
                    # If the direction is not recognised, print an error message
                    # and exit with an error code.
                    echo "Error: '$direction' isn't a recognised direction." >&2
                    exit $ERR_INPUT;;
            esac

            # Cancel out all full rotations from the dial_position. This value
            # is now constrained between -99 an 99.
            dial_position=$(( dial_position % 100 ))

            # If the constrained value is negative, it should wrap back around
            # past 100. Add 100 if it is negative to achieve this.
            if [[ "$dial_position" -lt 0 ]]; then
                dial_position=$(( dial_position + 100 ))
            fi

            # If a dial position of 0 was reached at the end of a movement,
            # increment the zero_landings counter.
            if [[ "$dial_position" -eq 0 ]]; then
                ((zero_landings++))
            fi
        else
            # If the rotation format is invalid, print an error message and
            # exit with an error code.
            echo "Error: Invalid rotation format '$rotation'." >&2
            exit $ERR_INPUT
        fi
    done

    # Write the solutions to the results nameref array:
    # - Part 1: number of times the dial landed on 0.
    # - Part 2: dummy value...
    results=("$zero_landings" "TODO")
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

    # Open the input file and read its contents to an array.
    local input_data
    mapfile -t input_data < "$input" || {
        echo "Error: Failed to parse input file $input." >&2
        exit $ERR_INPUT
    }

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
