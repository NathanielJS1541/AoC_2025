// A class to parse and store the contents of the maths worksheet from the input
// file.
//
// Author: Nathaniel Struselis
// SPDX-License-Identifier: AGPL-3.0-only

// Import the Problem class to represent a single problem from the worksheet.
import "./Problem" for Problem

class Worksheet {

    // The grand total of all problems parsed as Cephalopod maths in the
    // worksheet.
    cephalopodGrandTotal { _cephalopodGrandTotal }

    // The grand total of all problems parsed as "normal" maths in the
    // worksheet.
    normalGrandTotal { _normalGrandTotal }

    // Create an instance of the Worksheet class by parsing the input file data.
    construct parse(inputData) {
        // Split the input data into a list of lines for processing. Note that
        // the trailing newline character at the end of the file is first
        // removed to avoid creating an empty line at the end of the list. Not
        // all whitespace can be trimmed, however, as trailing spaces are part
        // of the data structure.
        var inputLines = inputData.trimEnd("\n").split("\n")

        // Use the static helper methods to parse the list of lines as both
        // Cephalopod maths and "normal" maths problems.
        var normalProblemData = Worksheet.parseAsNormalMaths(inputLines)
        var cephalopodProblemData = Worksheet.parseAsCephalopodMaths(inputLines)

        // Create a field to store the grand total when the maths problems are
        // parsed as "normal" maths.
        _normalGrandTotal = 0

        // Loop through each set of problem data when parsed as "normal" maths,
        // and create Problem instances for each.
        for (normalProblemData in normalProblemData) {
            // Parse the problem data into a Problem instance.
            var problem = Problem.parse(normalProblemData)

            // Add the answer from the parsed problem to the "normal" grand
            // total.
            _normalGrandTotal = _normalGrandTotal + problem.answer
        }

        // Create a field to store the grand total when the maths problems are
        // parsed as Cephalopod maths.
        _cephalopodGrandTotal = 0

        // Loop through each set of problem data when parsed as Cephalopod
        // maths, and create Problem instances for each.
        for (cephalopodProblemData in cephalopodProblemData) {
            // Parse the problem data into a Problem instance.
            var problem = Problem.parse(cephalopodProblemData)

            // Add the answer from the parsed problem to the Cephalopod grand
            // total.
            _cephalopodGrandTotal = _cephalopodGrandTotal + problem.answer
        }
    }

    // A helper method to parse the input lines and return it as a list of
    // lists, representing a 2D array of the worksheet. Each inner list
    // represents a "problem" in the worksheet, parsed as Cephalopod Maths where
    // the numbers are read top to bottom, right to left. The operators are at
    // the end of each problem.
    static parseAsCephalopodMaths(inputLines) {
        // Initialise a list to hold the parsed problem data, along with the
        // current number of the problem being parsed.
        var problemData = [[]]
        var problemNumber = 0

        // Estimate the number of characters in each row of the data. Assume
        // that all rows have the same number of characters.
        //
        // 1 is subtracted here to account for the fact that the column loop
        // runs backwards, and ranges in Wren are always inclusive if the start
        // value. Subtracting 1 puts the count into the correct range for
        // 0-based list indexing.
        var inputColumns = inputLines[0].trim("\n").count - 1

        // Count the number of rows in the input data. Since the row loop runs
        // forward, it uses a range which is exclusive of the end value, so 1
        // does not need to be subtracted.
        var inputRows = inputLines.count

        // Loop backwards through each column of the input data, as Cephalopod
        // maths reads the vertically annotated numbers from right to left.
        for (colIndex in inputColumns..0) {
            // Initialise a flag to track whether all characters in the current
            // column are spaces.
            var allSpaces = true

            // Initialise the strings to build up the current number and store
            // the operator at the end of the current column.
            var numberString = ""
            var operatorString = ""

            // Loop through each row in the current column to read the digits
            // vertically from top to bottom. Cephalopod maths reads the digits
            // in each number from top to bottom.
            for (rowIndex in 0...inputRows) {
                // Get the character at the current row and column.
                var char = inputLines[rowIndex][colIndex]

                // Check the character "class", and process it accordingly.
                if ("0123456789".contains(char)) {
                    // If the character is a digit, append it to the current
                    // number string.
                    numberString = numberString + char
                } else if ("+*".contains(char)) {
                    // If the character is an operator, store it as the current
                    // operator string. There should only be one operator per
                    // column, so it should just be stored.
                    operatorString = char
                }

                // If the character is not a space, set the all-spaces flag to
                // false. This indicates that the current column contains data.
                if (char != " ") {
                    allSpaces = false
                }
            }

            // Process the column based on whether it contained any data.
            if (allSpaces) {
                // If the column contained only spaces, it indicates the end
                // of the current problem. Increment the problem number and add
                // a new empty list to hold the next problem's data.
                problemData.add([])
                problemNumber = problemNumber + 1
            } else {
                // If the column contained data, add the parsed number to the
                // current problem's data, first parsing it as a number.
                problemData[problemNumber].add(Num.fromString(numberString))

                // If there was an operator at the end of the column, add it to
                // the current problem's data. This is done after the number to
                // ensure it appears last in the problem.
                if (operatorString != "") {
                    problemData[problemNumber].add(operatorString)
                }
            }
        }

        // Return the parsed problem data.
        return problemData
    }

    // A helper method to parse the input lines and return it as a list of
    // lists, representing a 2D array of the worksheet. Each inner list
    // represents a "problem" in the worksheet, parsed as "normal" Maths where
    // the numbers are read left to right, top to bottom. The operators are at
    // the end of each problem.
    static parseAsNormalMaths(inputLines) {
        // Initialise a list to hold the parsed problem data.
        var problemData = [[]]

        // Loop through each row in the input data to build up all of the
        // problem data in parallel, from top to bottom.
        for (rowIndex in 0...inputLines.count) {
            // Initialise the current problem number being parsed in this row.
            // Each row contains data for all problems, so this number is reset
            // at the start of each row.
            var problemNumber = 0

            // Initialise the strings to build up the current number and
            // operator being parsed as each column in the row is processed.
            //
            // The numberString and operatorString are cleared internally when
            // the end of a column of problem data is reached.
            var numberString = ""
            var operatorString = ""

            // Loop through each character in the current row to parse it into
            // the problem data for each problem.
            for (colIndex in 0...inputLines[rowIndex].count) {
                // Get the character at the current row and column.
                var char = inputLines[rowIndex][colIndex]

                // Check the character "class", and process it accordingly.
                if ("0123456789".contains(char)) {
                    // If the character is a digit, append it to the current
                    // number string.
                    numberString = numberString + char
                } else if ("+*".contains(char)) {
                    // If the character is an operator, store it as the current
                    // operator string. There should only be one operator per
                    // column, so it should just be stored.
                    operatorString = char
                } else if (char == " ") {
                    // If a space character has been reached, then the end of a
                    // problem "column" has been reached as spaces are used to
                    // separate the columns.
                    //
                    // Check if a number or operator was parsed before the
                    // space, since spaces can appear as padding at the start of
                    // a column, in which case they can be ignored.
                    if (numberString != "" || operatorString != "") {
                        // If the parsed column contained either a number or an
                        // operator, it can be added to the problem data for the
                        // current problem.

                        // Ensure that the problem data list has an inner list
                        // for the current problem number. This should only need
                        // to run for the first row of input data.
                        if (problemNumber >= problemData.count) {
                            // The parsed data is the first data for this
                            // problem, so add a new empty list to hold it.
                            problemData.add([])
                        }

                        // The parsed data will be either a parsed number or an
                        // operator, never both. Check which it is and add it to
                        // the current problem's data. Note that the
                        // numberStrings are parsed as numbers before being
                        // added.
                        if (numberString != "") {
                            problemData[problemNumber].add(
                                Num.fromString(numberString)
                            )
                        } else if (operatorString != "") {
                            problemData[problemNumber].add(operatorString)
                        }

                        // Clear the number and operator strings to prepare to
                        // parse the next column in the row.
                        numberString = ""
                        operatorString = ""
                        problemNumber = problemNumber + 1
                    }
                }
            }
        }

        // Return the parsed problem data.
        return problemData
    }
}
