// A class to parse and store the command line arguments passed to the Wren
// process when it was spawned.
//
// Author: Nathaniel Struselis
// SPDX-License-Identifier: AGPL-3.0-only

// Import Process to access information about the currently running process.
import "os" for Process

class Arguments {

    // A bool indicating whether the help flag was passed in to the process.
    help { _help }

    // The input file path passed in to the process, or null if none was
    // provided.
    inputFile { _inputFile }

    // A list of all unknown command line arguments passed to the process.
    unknownArgs { _unknownArgs }

    // Create an instance of the Arguments class by parsing the command line
    // arguments passed to the Wren process.
    construct parse() {
        // Get a list of the command line arguments passed in to the Wren
        // process.
        _args = Process.arguments

        // Set the initial field values for the parsed command line arguments.
        _help = false
        _inputFile = null
        _unknownArgs = []

        // Loop through each argument, storing them in the properties on this
        // class.
        var argIndex = 0
        while (argIndex < _args.count) {
            // Get the current argument.
            var arg = _args[argIndex]

            // Check the type of argument specified.
            if (arg == "--help" || arg == "-h") {
                // If the help argument was specified, set the help flag to
                // true.
                _help = true
            } else if (arg == "--input" || arg == "-i") {
                // If the input file argument was specified, the next argument
                // represents the input file path. Increment the argument index
                // and store the input file path.
                argIndex = argIndex + 1

                // Ensure the next argument exists before trying to access it.
                // If it doesn't, the input file path will remain null.
                if (argIndex < _args.count) {
                    // If there is a next argument, store it as the input file
                    // path.
                    _inputFile = _args[argIndex]
                }
            } else {
                // If the argument is unknown, store it in the list of unknown
                // arguments to be displayed as an error later.
                _unknownArgs.add(arg)
            }

            // Increment the argument index to move to the next argument.
            argIndex = argIndex + 1
        }
    }
}
