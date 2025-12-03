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

# Function to count the number of times the dial lands on or passes over 0 in
# the supplied input, and write the result to an array passed in by name.
#
# The solutions array passed by name will be updated to contain two elements:
# - [0]: The number of times the dial lands on 0.
# - [1]: The total number of times the dial passes over 0.
#
# Arguments:
# - $1: The name of the array variable containing the input data.
# - $2: The name of the array variable to write the solutions to.
#
# Usage:
#   count_zeros <input_array_name> <solutions_array_name>
count_zeros() {
    # Declare a nameref variable to the input array variable to access the input
    # data.
    local -n input=$1

    # Declare a nameref variable to the array to pass the results back to the
    # caller.
    local -n results=$2

    # Local variables to count the number of times the dial lands on 0, and the
    # number of times the dial passes over 0 without landing on it.
    local zero_landings=0 zero_passes=0

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

            # Cancel out all full rotations from the distance, as these are each
            # guaranteed to pass through 0 once and do not change the dial
            # value.
            if [[ "$distance" -gt 100 ]]; then
                zero_passes=$(( zero_passes + (distance / 100) ))
                distance=$(( distance % 100 ))
            fi

            # Update the dial position based on the direction and remaining
            # distance:
            # - Right moves the dial in the positive direction.
            # - Left moves the dial in the negative direction.
            local new_dial_position
            case "$direction" in
                R) new_dial_position=$(( dial_position + distance ));;
                L) new_dial_position=$(( dial_position - distance ));;
                *)
                    # If the direction is not recognised, print an error message
                    # and exit with an error code.
                    echo "Error: '$direction' isn't a recognised direction." >&2
                    exit $ERR_INPUT;;
            esac

            # The new_dial_position will now be in the range -99 to 198, as all
            # full rotations were accounted for above. Values outside of the
            # range 0-99 need to be constrained further, counting any zero
            # crossings.
            if [[ "$new_dial_position" -lt 0 ]]; then
                # If new_dial_position is negative, add 100 to cause it to "wrap
                # around" back past 99.
                new_dial_position=$(( new_dial_position + 100 ))
                # If the dial position before the move was not 0, then the move
                # must have passed 0. If the dial was already at 0, it was
                # already counted when the dial landed on 0.
                if [[ "$dial_position" -ne 0 ]]; then
                    ((zero_passes++))
                fi
            elif [[ "$new_dial_position" -ge 100 ]]; then
                # If new_dial_position is 100 or greater, subtract 100 to cause
                # it to "wrap around" back past 0.
                new_dial_position=$(( new_dial_position - 100 ))
                # This always causes the dial to cross 0. However, there is a
                # check later to count when the dial lands on 0, so only
                # increment here if the dial only passes 0.
                if [[ "$new_dial_position" -ne 0 ]]; then
                    ((zero_passes++))
                fi
            fi

            # If a dial position of 0 was reached at the end of a movement,
            # increment the zero_landings counter.
            if [[ "$new_dial_position" -eq 0 ]]; then
                ((zero_landings++))
            fi

            # Update the dial position for the next iteration.
            dial_position=$new_dial_position
        else
            # If the rotation format is invalid, print an error message and
            # exit with an error code.
            echo "Error: Invalid rotation format '$rotation'." >&2
            exit $ERR_INPUT
        fi
    done

    # Write the solutions to the results nameref array:
    # - Part 1: the number of times the dial lands on 0.
    # - Part 2: the total number of times the dial passes 0.
    results=("$zero_landings" "$((zero_landings + zero_passes))")
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

    # Pass the input data and solutions arrays by name to the function to count
    # the number of times the dial lands on and passes over 0 in the data. The
    # solutions array will contain two separate counts:
    # - The number of times the dial lands on 0.
    # - The total number of times the dial passes 0.
    count_zeros input_data solutions

    # Print the solutions to stdout.
    echo "AoC 2025 Day 01 Solutions:"
    echo "Part 1: ${solutions[0]}"
    echo "Part 2: ${solutions[1]}"
}

# Invoke main script logic with all positional arguments.
main "$@"
