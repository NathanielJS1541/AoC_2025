#!/usr/bin/env nu
#
# Solutions to Day 05 of the Advent of Code 2025 challenge written in nushell.
#
# Author: Nathaniel Struselis
# SPDX-License-Identifier: AGPL-3.0-only

# Constant defining the separator between the fresh ingredient ID ranges and the
# list of ingredient IDs in the input file.
#
# The list of ID ranges comes before the separator, and the list of ingredient
# IDs comes after it.
const range_end_separator: string = "\n\n"

# Check if a given ingredient ID falls within any of the provided "fresh" ID
# ranges.
#
# Returns true if the ingredient ID is "fresh", false otherwise.
def is_id_fresh [
    id: int # The ingredient ID to check.
    fresh_ranges: table<min: int, max: int> # The table of "fresh" ID ranges.
]: [
    nothing -> bool
] {
    # Check if the provided ID falls within any of the ranges in the
    # fresh_ranges table.
    $fresh_ranges
    | any {|row| ($id >= $row.min) and ($id <= $row.max) }
}

# Calculate the number of fresh ingredients, and the total number of unique
# fresh ingredient IDs in the provided input file.
#
# Returns a record containing two fields:
# - fresh_ingredients: The number of ingredient IDs that fall within the "fresh"
#   id ranges.
# - total_fresh_ids: The total number of unique ingredient IDs that fall within
#   any of the fresh ID ranges.
def main [
    input_path: path # Path to the challenge input file.
]: [
    nothing -> record<fresh_ingredients: int, total_fresh_ids: int>
] {
    # Open the input file and split it into two sections: the fresh ingredient
    # ID ranges and the list of ingredient IDs.
    #
    # The input file for AoC challenges is typically a plain text file with no
    # specific extension. To ensure consistent behaviour:
    # - open ... --raw is used to always read the file as raw bytes.
    # - decode utf-8 is used to parse the bytes as their expected format.
    # - split row --number 2 is used to split the input into the two sections
    #   either side of the defined separator.
    #
    # This should always yield a list<string> containing exactly two elements:
    # - The first element contains the fresh ingredient ID ranges.
    # - The second element contains the list of ingredient IDs.
    let raw_input: list<string> = open $input_path --raw
    | decode utf-8
    | split row --number 2 $range_end_separator

    # Parse the fresh ingredient ID ranges into a table with "min" and "max"
    # columns, and parse the ingredient IDs into a list of integers:
    # - lines: Split the input into a list containing one range per element.
    # - parse --regex: Use a regular expression to extract the "min" and "max"
    #   values from each range into named columns.
    # - update cells ... into int: Convert the extracted string values into
    #   integers.
    # - sort-by min: Sort the ranges by their minimum value to facilitate
    #   removing overlapping sections of ranges later on.
    let fresh_ranges: table<min: int, max: int> = $raw_input.0
    | lines
    | parse --regex '^(?P<min>\d+)-(?P<max>\d+)$'
    | update cells {|| into int }
    | sort-by min

    # Parse the ingredient IDs into a list of integers:
    # - lines: Split the input into a list containing one ingredient ID per
    #   element.
    # - par-each {|| into int }: Convert each ingredient ID from a string into
    #   an integer in parallel.
    let ingredient_ids: list<int> = $raw_input.1
    | lines
    | par-each {|| into int }

    # Calculate the number of fresh ingredients in the supplied ingredient IDs:
    # - par-each {|id| ... }: For each ingredient ID, check if it is fresh using
    #   the is_id_fresh function. Return 1 if it is fresh, 0 otherwise. This is
    #   done in parallel to speed up processing.
    # - math sum: Sum the results to get the total number of fresh ingredients.
    let fresh_ingredients: int = $ingredient_ids
    | par-each {|id| if (is_id_fresh $id $fresh_ranges) { 1 } else { 0 } }
    | math sum

    # Calculate the total number of unique fresh ingredient IDs that are covered
    # by the provided fresh ID ranges.
    #
    # Note that some of the ID ranges overlap, so any overlapping ranges must be
    # truncated. This requires the $fresh_ranges table to be sorted by the "min"
    # column beforehand.
    #
    # The following approach is used to trim the ranges:
    # - reduce --fold: Iterate over each range, maintaining an accumulator with
    #   the last maximum value seen and the running sum of the number of unique
    #   fresh IDs.
    # - get count: Extract the final count of unique fresh IDs from the
    #   accumulator.
    let total_fresh_ids: int = $fresh_ranges
    | reduce --fold { last_max: -1, count: 0 } {|it, acc|
        # Check if the minimum of the current range overlaps with the previous
        # range.
        let start: int = if $it.min > $acc.last_max {
            # If the current range does not overlap, use its minimum value as
            # the start of the range.
            $it.min
        } else {
            # If the current range overlaps, start at the value immediately
            # after the end of the last range.
            $acc.last_max + 1
        }

        # Check if the range is valid after removing any overlap, and update the
        # accumulator accordingly.
        if $it.max >= $start {
            # If the range is valid, set the new accumulator maximum and update
            # the count of unique fresh IDs to include the number of IDs in this
            # range.
            { last_max: $it.max, count: ($acc.count + ($it.max - $start + 1)) }
        } else {
            # If the range is not valid (i.e. would need to start after the
            # maximum of the range to prevent overlap) return the original
            # accumulator, as its value doesn't need to be updated.
            $acc
        }
    }
    | get count

    # Return the number of fresh ingredients in the list of ingredient IDs, and
    # the total number of unique fresh ingredient IDs covered by the provided
    # fresh ID ranges.
    {
        fresh_ingredients: $fresh_ingredients
        total_fresh_ids: $total_fresh_ids
    }
}
