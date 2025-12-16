#!/usr/bin/env wren_cli
//
// Solutions to Day 06 of the Advent of Code 2025 challenge written in Wren.
//
// Author: Nathaniel Struselis
// SPDX-License-Identifier: AGPL-3.0-only

// Import the Arguments class to parse command line arguments.
import "./Arguments" for Arguments

// Import the Worksheet class to parse the input data.
import "./Worksheet" for Worksheet

// Import the File class from the io module to read the input data from a file.
import "io" for File

// A message to display when the script usage information is requested.
var USAGE = """
Usage: wren_cli day06.wren -i ./input

Read challenge input data from a text file and calculate the solutions to Day 06
of the Advent of Code challenge.

Options:
    -h or --help                  Print this message and exit.
    -i or --input <input_path>    [REQUIRED] Path to the challenge input file.
"""

// Exit code definitions.
var ERR_OK = 0
var ERR_HELP = 1
var ERR_ARGS = 2

// Parse the command line arguments passed to the Wren process.
var args = Arguments.parse()

// Verify the parsed command line arguments and handle any early returns
// required by the provided arguments.
if (args.help) {
    // If the help flag was passed in, display the help message and exit. The
    // exit code here is non-zero to indicate that the main program logic didn't
    // run.
    System.print(USAGE)
    return ERR_HELP
} else if (args.inputFile == null) {
    // If no input file path was provided, display an error message and exit.
    System.print("Error: No input file path provided. See --help for usage.")
    return ERR_ARGS
} else if (File.exists(args.inputFile) == false) {
    // If the input file path provided doesn't exist, display an error message
    // and exit.
    System.print("Error: The input file '%(args.inputFile)' doesn't exist.")
    return ERR_ARGS
} else if (args.unknownArgs.count > 0) {
    // If there were unknown arguments provided, display an error message and
    // exit.
    var unknownArgs = args.unknownArgs.join(", ")
    System.print("Error: Invalid args: %(unknownArgs). See --help for usage.")
    return ERR_ARGS
}

// Read the input data from the specified input file.
var inputData = File.read(args.inputFile)

// Parse the input data into a Worksheet instance.
var worksheet = Worksheet.parse(inputData)

// Print the calculated grand totals for each problem.
System.print("'Normal' grand total: %(worksheet.normalGrandTotal)")
System.print("'Cephalopod' grand total: %(worksheet.cephalopodGrandTotal)")
