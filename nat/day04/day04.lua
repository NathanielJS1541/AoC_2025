#!/usr/bin/env lua
-- Solutions to Day 04 of the Advent of Code 2025 challenge written in lua.
--
-- Author: Nathaniel Struselis
-- SPDX-License-Identifier: AGPL-3.0-only

-- String to display as the usage information.
local USAGE = [[
Usage: lua day04.lua -i ./input

Read challenge input data from a text file and calculate the solutions to Day 04
of the Advent of Code challenge.

Options
    -h or --help                  Print this message and exit.
    -i or --input <input_path>    [REQUIRED] Path to the challenge input file.
]]

-- Table defining the exit codes for the script.
local EXIT_CODE = {
    -- Exit code for when the script exits successfully.
    SUCCESS = 0,
    -- Exit code when the help information is requested. This is different to
    -- the success exit code to indicate that the main script logic didn't run.
    HELP = 1,
    -- Exit code that happens when argument parsing fails.
    ARGUMENT_ERROR = 2,
    -- Exit code that happens when the input file cannot be opened.
    INPUT_ERROR = 3
}

-- Constants defining the characters used in the input data.
local PAPER_ROLL = '@'
local EMPTY = '.'

-- This constant defines the maximum number of adjacent rolls that can surround
-- a roll before it is classed as inaccessible.
local MAX_ADJACENT_ROLLS = 4

-- Create a 2D array from the input file, where each character in the file is in
-- a separate cell of the array.
--
-- Arguments:
-- - input_file: A readable file object containing the input data.
--
-- Returns:
-- - A 2D array where each row corresponds to a line in the input file, and each
--   cell in the row contains a character from that line.
local function create_input_array(input_file)
    -- Create a 2D array to hold the input data.
    local input = {}

    -- Read each line from the input file and convert it into a row in the
    -- array.
    for line in input_file:lines() do
        -- Create a new row for the current line.
        local row = {}

        -- Iterate over each character in the line and insert it into the row.
        -- This uses gmatch to match each character (".") in the line.
        for char in line:gmatch(".") do
            table.insert(row, char)
        end

        -- Insert the row into the input array.
        table.insert(input, row)
    end

    -- Return the 2D array containing the input data.
    return input
end

-- Count the number of rolls immediately adjacent to a roll in a particular
-- cell.
--
-- Arguments:
-- - input_data: A 2D array where each row corresponds to a line in the input
--   file, and each cell in the row contains a character from that line.
-- - row: The row index of the cell to check (1-based).
-- - col: The column index of the cell to check (1-based).
--
-- Returns:
-- - The number of rolls immediately adjacent to the roll in the specified cell.
local function get_adjacent_roll_counts(input_data, row, col)
    -- Initialise the total of adjacent rolls to 0.
    local adjacent_rolls = 0

    -- Calculate the maximum row number in the input data. This doesn't change,
    -- so only needs to be calculated once.
    local max_row = #input_data

    -- Loop through each adjacent row in the input_data.
    for row_offset = -1, 1 do
        -- Calculate the adjacent row index based on the current row and offset.
        local adj_row = row + row_offset

        -- Check if the adjacent row index is valid within the input data.
        if adj_row >= 1 and adj_row <= max_row then
            -- Get the maximum column index for the current row.
            local max_col = #input_data[adj_row]

            -- If the adjacent row index is valid, loop through each adjacent
            -- column within the adjacent row.
            for col_offset = -1, 1 do
                -- Calculate the adjacent column index based on the current
                -- column and offset.
                local adj_col = col + col_offset

                -- Check if the adjacent column index is valid within the input
                -- data.
                if adj_col >= 1 and adj_col <= max_col then

                    -- Check that the adjacent row and column are not the
                    -- indexes of the cell being checked. This prevents counting
                    -- the cell itself as an adjacent roll.
                    if not (adj_row == row and adj_col == col) then
                        -- Get the value of the current adjacent cell.
                        local adjacent_cell = input_data[adj_row][adj_col]

                        -- Check if the adjacent cell contains a paper roll.
                        if adjacent_cell == PAPER_ROLL then
                            -- If it does, increment the count of
                            -- adjacent_rolls.
                            adjacent_rolls = adjacent_rolls + 1
                        end
                    end
                end
            end
        end
    end

    -- Return the total number of adjacent rolls found.
    return adjacent_rolls
end

-- Calculate the number of rolls of paper that can be accessed by a forklift in
-- the given input data.
--
-- Arguments:
-- - input_data: A 2D array where each row corresponds to a line in the input
--   file, and each cell in the row contains a character from that line.
--
-- Returns:
-- - A table containing the number of rolls that are accessible to forklifts
--   under two different conditions:
--   - immediate_access: The rolls are immediately accessible to forklifts.
--   - total_access: The total number of rolls accessible to forklifts,
--     including those that become accessible after other rolls are removed.
local function main(input_data)
    -- Initialise counters for the number of rolls that can be accessed.
    local immediate_access = 0
    local total_access = 0

    -- Calculate the maximum row number in the input data. This doesn't change,
    -- so only needs to be calculated once.
    local max_row = #input_data

    -- A flag to indicate whether the initial analysis of the input data has
    -- been done. This is used to differentiate between the first pass (which is
    -- effectively a read-only initial analysis) and subsequent passes where the
    -- input data can be modified as rolls are removed.
    local initial_analysis_done = false

    -- A flag to indicate whether the input_data has remained unchanged after
    -- processing. The processing loop will run until no more changes are made.
    local unchanged = false

    -- Process the data until it is no longer changed during an iteration. This
    -- loop performs two different types of analysis:
    -- 1. The first iteration performs an initial analysis of the input data,
    --    counting only the immediately accessible rolls.
    -- 2. Subsequent iterations count the total number of accessible rolls,
    --    removing rolls from the input data as they are counted. This allows
    --    the analysis to continue until no more rolls can be accessed.
    while not unchanged do
        -- In each iteration, assume the input data is unchanged. This flag will
        -- then be set when the data is modified.
        unchanged = true

        -- Loop through each row in the input_data.
        for row_index = 1, max_row do
            -- Get the maximum column index for the current row.
            local max_col = #input_data[row_index]

            -- Loop through each column in the current row.
            for column_index = 1, max_col do
                -- Get the item at the current row and column.
                local current_cell = input_data[row_index][column_index]

                -- Check if the current cell is a paper roll. If it is, then we
                -- need to check if it can be accessed.
                if current_cell == PAPER_ROLL then
                    -- Count the number of adjacent rolls to the current roll.
                    local adjacent_rolls = get_adjacent_roll_counts(
                        input_data,
                        row_index,
                        column_index
                    )

                    -- Check if the current roll is accessible by a forklift.
                    if adjacent_rolls < MAX_ADJACENT_ROLLS then
                        -- Check whether the initial analysis is being
                        -- performed, or whether the input_data can be modified.
                        if not initial_analysis_done then
                            -- If the initial analysis is not done, then only
                            -- immediately accessible rolls are counted.
                            immediate_access = immediate_access + 1
                            -- The input_data is not modified during the initial
                            -- analysis.
                        else
                            -- If the initial analysis is complete, then the
                            -- total number of accessible rolls are being
                            -- counted.
                            total_access = total_access + 1

                            -- After it is counted, remove the roll from the
                            -- input data. This may make adjacent rolls
                            -- accessible in future iterations.
                            input_data[row_index][column_index] = EMPTY

                            -- Set the unchanged flag to false, as the
                            -- input_data has been modified.
                            unchanged = false
                        end
                    end
                end
            end
        end

        -- After processing all rows and columns, check if iteration performed
        -- the initial analysis without modifying the input.
        if not initial_analysis_done then
            -- If the previous iteration was the analysis step, then set the
            -- flag to true so future iterations will be able to modify the
            -- input_data.
            initial_analysis_done = true
            -- Although the input_data has not been modified, set unchanged to
            -- false here to ensure the loop continues. This saves setting it in
            -- each iteration, as the analysis only runs once during the first
            -- iteration.
            unchanged = false
        end
    end

    -- Return the number of rolls that can be accessed immediately and the total
    -- number of rolls that can be accessed as a table.
    return {
        immediate_access = immediate_access,
        total_access = total_access
    }
end

-- Parse the command line options provided to the script, returning them as a
-- table of options.
--
-- Arguments:
-- - args: A table containing the arguments passed to the script.
--
-- Returns:
-- - A table of options parsed from the command line arguments. The table will
--   contain the following keys:
--   - help: A boolean indicating if the help option was requested.
--   - input_path: The path to the input file, or nil if not provided.
--   - missing_value: A boolean indicating if a required option value was
--     missing.
--   - missing_value_option: The name of the option that was missing a value.
--   - unknown_option: A boolean indicating if an unknown option was provided.
--   - unknown_option_name: The name of the unknown option that was provided.
local function parse_options(args)
    -- Create a table to store the options parsed from the command line, setting
    -- initial values for each option.
    local options = {
        -- Boolean flag to indicate if the script help was requested.
        help = false,
        -- The input file path, which is required. This will be set to nil if
        -- the option is not provided.
        input_path = nil,
        -- This flag and value will be used to indicate that an option that
        -- requires a value was provided without one.
        missing_value = false,
        missing_value_option = nil,
        -- This flag and value will be used to indicate that an unknown option
        -- was provided.
        unknown_option = false,
        unknown_option_name = nil
    }

    -- Index variable to track the current argument being processed. This starts
    -- at 1, as the first argument is the script name at args[0].
    local arg_index = 1

    -- Loop through each provided argument, parsing each option into an array to
    -- return.
    while arg_index <= #args do
        -- Extract the current argument.
        local arg = args[arg_index]

        -- Check if the argument is a recognised option.
        if arg == "-h" or arg == "--help" then
            -- If the help flag is provided no value is required, just store a
            -- boolean flag.
            options.help = true
            -- Break out of the parse loop early, as no other options are
            -- compatible with the help option.
            break
        elseif arg == "-i" or arg == "--input" then
            -- The input option requires a value, so check if a following
            -- argument was provided.
            if arg_index + 1 > #args then
                -- If no value is provided, set the missing option flag and
                -- store the option name.
                options.missing_value = true
                options.missing_value_option = arg
                -- Break out of the parse loop early to report the missing
                -- value.
                break
            else
                -- If a value is provided, store it in the options table.
                -- Increment the index to skip the value in the next iteration.
                options.input_path = args[arg_index + 1]
                arg_index = arg_index + 1
            end
        else
            -- If the argument is not recognised, set the unknown option flag
            -- and store the unknown option name.
            options.unknown_option = true
            options.unknown_option_name = arg
            -- Break out of the parse loop early to report the unknown option.
            break
        end

        -- Increment the argument index to move to the next argument.
        arg_index = arg_index + 1
    end

    -- Return the parsed options table.
    return options
end

-- Parse the command line options provided to the script.
local options = parse_options(arg)

-- Check the parsed options, returning early when required. These are checked in
-- priority order.
if options.help then
    -- If the help option is provided, print the usage information and exit.
    print(USAGE)
    os.exit(EXIT_CODE.HELP)
elseif options.missing_value then
    -- If a required option value is missing, write an error message and the
    -- usage information to stderr, then exit with the ARGUMENT_ERROR exit code.
    io.stderr:write(
        "Error: Missing value for option '" ..
        options.missing_value_option ..
        "'.\n"
    )
    io.stderr:write(USAGE)
    os.exit(EXIT_CODE.ARGUMENT_ERROR)
elseif options.unknown_option then
    -- If an unknown option is provided, write an error message and the usage
    -- information to stderr, then exit with the ARGUMENT_ERROR exit code.
    io.stderr:write(
        "Error: Unknown option '" ..
        options.unknown_option_name ..
        "'.\n"
    )
    io.stderr:write(USAGE)
    os.exit(EXIT_CODE.ARGUMENT_ERROR)
elseif not options.input_path then
    -- If the input path is not provided, write an error message and the usage
    -- information to stderr and exit with the ARGUMENT_ERROR exit code.
    io.stderr:write("Error: Input file path (-i or --input) is required.\n")
    io.stderr:write(USAGE)
    os.exit(EXIT_CODE.ARGUMENT_ERROR)
end

-- Try and open the input file.
local input_file = io.open(options.input_path, "r")

-- If the file cannot be opened, write an error message to stderr and exit with
-- the INPUT_ERROR exit code.
if not input_file then
    io.stderr:write(
        "Error: Could not open input file '" ..
        options.input_path ..
        "'."
    )
    io.stderr:write(USAGE)
    os.exit(EXIT_CODE.INPUT_ERROR)
end

-- Read the input file and create a 2D array from the input data.
-- This will throw an error if the file cannot be read, which will be caught by
-- the pcall function.
local input_ok, input_data = pcall(create_input_array, input_file)

-- Always close the input file after reading.
-- This is done outside the pcall to ensure the file is closed even if an error
-- occurs while reading.
input_file:close()

-- If the file could not be parsed, write an error message to stderr and exit
-- with the INPUT_ERROR code.
if not input_ok then
    io.stderr:write(
        "Error: Could not parse input file '" ..
        options.input_path ..
        "'."
    )
    os.exit(EXIT_CODE.INPUT_ERROR)
end

-- Call the main function with the provided input data. If input_ok == true,
-- then the input_data is the 2D array returned by the create_input_array
-- function.
local result = main(input_data)

-- Print the results of the calculations.
print("Immediately accessible rolls: " .. result.immediate_access)
print("Total accessible rolls: " .. result.total_access)
