// A class to represent and parse a single problem from the maths worksheet.
//
// Author: Nathaniel Struselis
// SPDX-License-Identifier: AGPL-3.0-only

class Problem {

    // The calculated numeric answer to the problem.
    answer { _answer }

    // The operator that was applied to the numbers to calculate the answer.
    operator { _operator }

    // The list of numbers (in string representation) to calculate the answer
    // with.
    numbers { _numbers }

    // Create an instance of the Problem class by parsing a single column from
    // the worksheet. A column is expected to be a list of numbers, with the
    // operator as the last element in the list as a string.
    construct parse(worksheetColumn) {
        // Remove the operator from the end of the column, storing it in the
        // operator field.
        _operator = worksheetColumn.removeAt(worksheetColumn.count - 1)

        // Store the remainder of the column as the list of numbers.
        _numbers = worksheetColumn

        // Initialise the answer to the first number in the list. This is needed
        // as the operator is applied as a running total.
        _answer = _numbers[0]

        // Loop through the remaining numbers, applying the operator to each in
        // turn to calculate the final answer.
        for (numberIndex in 1..._numbers.count) {
            // Calculate the answer by applying the operator to the running
            // answer and the current number. Note that the number strings are
            // converted to numbers before the operation is applied.
            if (_operator == "+") {
                _answer = _answer + _numbers[numberIndex]
            } else if (_operator == "*") {
                _answer = _answer * _numbers[numberIndex]
            } else {
                // If the operator is unrecognised, raise a runtime error.
                Fiber.abort("Error: Unrecognised operator '%(_operator)'.")
            }
        }
    }

}
