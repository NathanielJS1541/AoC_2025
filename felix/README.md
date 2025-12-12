# Felix's Advent of Code 2k25

```text
.      .           \|/ .                   .                    .        .
  .      .    .   - * -   .        .            .          .                .
 .  .      .    .  /|\        .         .           .            .     .
   .     .    .     .        .   .         .             .         .  .     .
   .  .     . ^    . Vv   Vv   Vv   Vv       .         .     .       .  .    .
.   .      x  O      o,   o,   o,   o,       .      .    .      .         .  
.        /(_){-}+--===--===--===--===    .        .          .      .  ~~~~
  .      \=====/   > >  > >  > >  > >      .           .  .    .     .  ~~~
.     .     .       .         .                 .           .     .     . ~~ .
    .    .       .        .          .   .           .         .     .     ~~~
.          .   .       .        .        .        .          .      .   /\  ~~
 .     .           .    ^    .    .   ^       .         .      .     . /  \ ||
                       /|\           /|\                              / [] \||
#### ^ ############ ## /|\ ##  ##### /|\ #####################       /      ||
##  /|\ ########## ^  #####   ^    ################################ / []  []  \
#   /|\ ######### /|\####### /|\ ####   #### ^ ####  #############  |         |
## #### ## ^   #  /|\ ###### /|\ #### ^ ### /|\ #  ^  ##########    |  _   _  |
########  /|\ ###################### /|\ ## /|\ # /|\ ##        +===| [_] [_] |
#######   /|\  ####################  /|\ #######  /|\           +---|         |
###############################################################################
```

Abandon hope, all ye who enter here.

This year I will be abusing Excel some more, but with the strict rule that all formulas must be in a single cell to ensure proper
 functional programming.
 
I'll be uploading my solutions as .txt files of the Excel formula from that cell.

Prepare yourself for some awful hacks.


Day 01
===================================================================================================================================

Came into some issues with Excel's max stack depth while doing this one. The limit applies to both the recursion depth and number
 of LETs, so forgive all the repetition.

Without the recursion limits, d1p1 would be as below. I've added C-style comments since Excel doesn't have comments built-in.
```
=LET(
    // Pre-processing
    input, A2:A11, // Get input range
    nums, NUMBERVALUE(MID(input, 2, LEN(input)-1)), // Get number part of input range
    signedNums, IF(LEFT(input, 1)="L", -1*nums, nums), // Use the 'L'/'R' to set the sign of the numbers
    
    // Define lambda function
    // Since F isn't defined within the definition of F, we have to pass F in as the parameter G.
    F, LAMBDA(G,pos,L,
        // If current position is 0, add one. If there's more elements left in the list, update pos and recurse.
        IF(pos=0, 1, 0) + IF(ROWS(L)>1, G(G, MOD(pos+INDEX(L,1), 100), DROP(L, 1)), 0)
    ),
    
    // Recursion
    F(F,50, signedNums)
)
```

To avoid the recursion limit, two list elements are handled in each call. A similar technique is used in d1p2.

In retrospect, a MAP function would have saved a lot of recursive iteration faffing.


Day 2
===================================================================================================================================

Many learnings on MAPs and BYROWs today. Starting to develop a structured approach. Commented part 2 formula below.

```
=LET(

    // This function is called on each range defined in the input it returns the sum of all the invalid IDs in that range
    SUM_INVALID_IDS_IN_RANGE, LAMBDA(leftRight, LET(

        // Gets all factors of a number x, except x itself.
        // N.B.: FACTORS(1) = {}
        FACTORS, LAMBDA(x, LET(
            All, SEQUENCE(1, FLOOR.MATH(x / 2)),
            FILTER(All, MOD(INDEX(x, 1), All) = 0)
        )),

        // For a given range and chunk length, return all possible numbers made from repeated chunks of that length.
        RANGE_FACTOR_INVALID_IDS, LAMBDA(min,max,chunkLength,
            LET(
            multiChunkers, NUMBERVALUE(REPT(SEQUENCE(
                       1,
                        LEFT(max, chunkLength) - LEFT(min, chunkLength) + 1,
                        LEFT(min, chunkLength)
                    ),
                    LEN(min) / chunkLength
            )),
            IFERROR(FILTER(multiChunkers, (multiChunkers >= min) * (multiChunkers <= max) * (LEN(multiChunkers) > 1)), 0)
            )
        ),

        // Finds all possible numbers within a range made from two or more repeated chunks.
        // min and max must have the same number of digits
        RANGE_INVALID_IDS, LAMBDA(min,max,
            IF(LEN(min) = 1,
                0,
                DROP(REDUCE(0, FACTORS(LEN(min)),
                         LAMBDA(acc,f, HSTACK(acc, RANGE_FACTOR_INVALID_IDS(min, max, f)))
                ), , 1)
            )
        ),

        // Finds all possible numbers within a range made from two or more repeated chunks.
        // Min and max can differ in number of digits by at most 1.
        GET_INVALID_IDS, LAMBDA(min,max,
            IF(LEN(min) = LEN(max),
                RANGE_INVALID_IDS(min, max),
                HSTACK(
                    RANGE_INVALID_IDS(min, NUMBERVALUE(REPT("9", LEN(min)))),
                    RANGE_INVALID_IDS(NUMBERVALUE(CONCAT("1", REPT("0", LEN(max) - 1))), max)
                )
            )
        ),

        // Parse input row
        left, INDEX(leftRight, 1),
        right, INDEX(leftRight, 2),

        // Get all the invalid IDs in this range and filter down to unique values
        // N.B.: UNIQUE only works on columns, so some transposing is required.
        invalidIDs, TRANSPOSE(UNIQUE(TRANSPOSE(GET_INVALID_IDS(left, right)))),

        // Return the sum of the invalid IDs in this range
        SUM(invalidIDs)
    )),

    // Split the input into rows by "," and iterate through each row
    r, BYROW(
        NUMBERVALUE(TEXTSPLIT(A1, "-", ",")),
        LAMBDA(row, SUM_INVALID_IDS_IN_RANGE(row))
    ),

    // Return the sum of the invalid IDs in all ranges
    SUM(r)
)
```


Day 3
===================================================================================================================================

Found today much easier than day 2, maybe because the problem more naturally lends itself to functional programming, maybe because
 I'm getting better?

```
=LET(

    // Takes an input row and gets the (string) 12-digit number result
    DO_ROW, LAMBDA(ROW,
        LET(

            // Split the row out into individual digits
            allDigits, NUMBERVALUE(MID(ROW, SEQUENCE(1, LEN(ROW)), 1)),

            // Takes a sub-string and finds the maximum number that can be formed using numToChoose digits
            CHOOSE_DIGITS, LAMBDA(ME,digits, numToChoose,
                LET(

                    // Since we have to choose n digits from an m-digit number and keep them in order, the first chosen digit must
                    //  be in the first (m-n+1) digits. 
                    leftDigits, DROP(digits, 0, 1 - numToChoose),
                    first, MAX(leftDigits),
                    CONCAT(
                        first,

                        // If we've more digits to choose, then recurse, considering the part of the input number to the right of
                        //  the chosen digit.
                        IF(numToChoose > 1,
                            LET(
                                i_first, MATCH(first, leftDigits, 0),
                                rightDigits, DROP(digits, 0, i_first),
                                ME(ME, rightDigits, numToChoose - 1)
                            ),
                            ""
                        )
                    )
                )
            ),
            CHOOSE_DIGITS(CHOOSE_DIGITS, allDigits, 12)
        )
    ),

    // Sum the results of all the input rows
    SUM(NUMBERVALUE(BYROW(A1:A200, DO_ROW)))
)
```


Day 4
===================================================================================================================================

Did part 1 the Naiive way, but convolution seeemed so obvious when I realised it was the right tool for the job.

Commented part 2:

```
=LET(

    // Input data parsing - split into a 2D array of 1 and 0 padded with 0.
    input, A1:A140,
    nrows, ROWS(input),
    ncols, LEN(INDEX(input, 1)),
    PAD_ROW, LAMBDA(row, CONCAT(".", row, ".")),
    padded, VSTACK(
        REPT(".", ncols + 2),
        BYROW(input, PAD_ROW),
        REPT(".", ncols + 2)
    ),
    split, IF(MID(padded, SEQUENCE(1, ncols + 2), 1) = "@", 1, 0),

    // These two functions are based on [numpy.roll()](https://numpy.org/doc/2.1/reference/generated/numpy.roll.html)
    HROLL, LAMBDA(M, n,
        IF(n=0,
            M,
            IF(n > 0,
                HSTACK(DROP(M, 0, COLUMNS(M) - n), DROP(M, 0, -n)),
                HSTACK(DROP(M, 0, -n), DROP(M, 0, -n - COLUMNS(M)))
            )
        )
    ),
    VROLL, LAMBDA(M, n,
        IF(n = 0,
            M,
            IF(n > 0,
                VSTACK(DROP(M, ROWS(M) - n), DROP(M, -n)),
                VSTACK(DROP(M, -n),DROP(M,-n - ROWS(M)))
            )
        )
    ),

    // This function removes all the accessible rolls from a binary grid and returns a new grid.
    UPDATE, LAMBDA(M,
        LET(
        // Create copies of the grid M rotated right and left
        hrollLeft, HROLL(M, -1),
        hrollRight, HROLL(M, 1),

        // Create 8 total copies of the grid rotated to each of the adjacent positions and sum them all
        // Each cell now contains a value saying how many adjacent rolls it has.
        summed, VROLL(hrollLeft, -1)
              + hrollLeft
              + VROLL(hrollLeft, 1)
              + VROLL(M, -1)
              + VROLL(M, 1)
              + VROLL(hrollRight, -1)
              + hrollRight
              + VROLL(hrollRight, 1),

        // M is all 0 or 1, so subtract 1 from every cell with < 4 adjacents to remove that roll.
        M - (summed < 4) * M
        )
    ),

    // This function keeps removing all accessible rolls until an update runs where no changes are made.
    // It returns the total number of rolls which have been removed.
    UPDATE_UNTIL_STEADY, LAMBDA(ME, M, lastCount,
        LET(
            newM, UPDATE(M),
            newCount, SUM(newM),
            IF(newCount=lastCount,
                0,
                (lastCount-newCount) + ME(ME, newM, newCount)
            )
        )
    ),

    // Return the total number of rolls removed.
    UPDATE_UNTIL_STEADY(UPDATE_UNTIL_STEADY, split, SUM(split))
)
```


Day 05
===================================================================================================================================

Part 1: Initially did some complicated pre-processing to reduce overlapping ranges, but found that in the end this only halved
         the number of ranges and made little difference to computation time, so got rid of it for the final code.

Part 2: Result, already did this for my overcomplicated part 1 - just needed one extra lambda to calculate the number of IDs in
         each range of minimisedRanges.

Commented part 1 with pre-processing:
```
=LET(

    // Parse input
    hashSeparated, TEXTSPLIT(TEXTJOIN("#", FALSE, A1:A1175), , "##"),
    ranges, NUMBERVALUE(TEXTSPLIT(CONCAT(INDEX(hashSeparated, 1)), "-", "#")), // Single-parameter CONCAT to force string type
    availableIDs, NUMBERVALUE(TEXTSPLIT(CONCAT(INDEX(hashSeparated, 2)), "#")),

    // Sort the ranges by their start ID
    sortedRanges, SORTBY(ranges, BYROW(ranges, LAMBDA(row, INDEX(row, , 1)))),

    // Scans through the sorted list of ranges, splitting off a new range from the front every time a gap between ranges is found.
    MINIMISE_RANGES, LAMBDA(ME, s, e, list,
        IF(ROWS(list) > 1,
            LET(
                next_s, INDEX(list, 1, 1),
                next_e, INDEX(list, 1, 2),
                IF(next_s <= e + 1,
                    // No gap - combine the next range with the current range
                    ME(ME, s, MAX(e, next_e), DROP(list, 1)),

                    // Gap - split off the current range before continuing 
                    VSTACK(HSTACK(s, e), ME(ME, next_s, next_e, DROP(list, 1)))
                )
            ),
        VSTACK(HSTACK(s, e), list)
        )
    ),

    // Remove overlapping ranges
    minimisedRanges, DROP(MINIMISE_RANGES(MINIMISE_RANGES, -1, -1, sortedRanges), 1),

    // Checks whether a value x is in a 2-element range
    IN_RANGE, LAMBDA(x, range,
        ABS(SUM(SIGN(range - x))) < 2
    ),

    // If X is in any of the list of ranges provided, returns 1, otherwise 0.
    X_IN_RANGES, LAMBDA(x, ranges,
        LET(

        // Curried IN_RANGE for a specific X
        X_IN_RANGE, LAMBDA(range,
            IN_RANGE(x, range)
        ),

        IF(OR(BYROW(ranges, X_IN_RANGE)), 1, 0)
        )
    ),

    // Curried X_IN_RANGES for minimisedRanges
    XS_IN_MINIMISED_RANGES, LAMBDA(X,
        X_IN_RANGES(X, minimisedRanges)
    ),

    //Count the number of IDs which are in any range
    SUM(MAP(availableIDs, XS_IN_MINIMISED_RANGES))
)
```


Day 06
===================================================================================================================================

Part 1: Had a sneaky suspicion that the left/right justification might be important later so made a parser which keeps whitespace.

Part 2: As expected, that whitespace came in very handy - just a bit of transposing in each problem, otherwise it's all the same.


Commented part 2

```
=LET(
    input, A1:A5,

    // Number of operands in all the problems
    operandCount, ROWS(input) - 1,

    // Bottom row of '*' and '+'
    operators, TEXTSPLIT(INDEX(input, operandCount+1), " ", , TRUE),

    problemCount, COLUMNS(operators),
    operandRows, DROP(input, -1),

    // Width of the input in characters
    rowLenChars, LEN(INDEX(input, 1)),

    // Create a mask of where the space colummns are
    spaceMask, MID(operandRows, SEQUENCE(1, rowLenChars), 1) = " ",
    spaceColsMask, BYCOL(spaceMask, AND),
    
    // Takes a string and replaces the chars specified by spaceColsMask with '#'
    REPLACE_BY_MASK, LAMBDA(str,
        LET(
            asciiIn, CODE(MID(str, SEQUENCE(1, rowLenChars), 1)),
            replacedAscii, asciiIn + spaceColsMask * (CODE("#") - CODE(" ")),
            CONCAT(CHAR(replacedAscii))
        )
    ),

    // Turn concatenate the rows of operand data (each like x#y#z) by "|". Avoids illegal nested arrays.
    delimitedString, TEXTJOIN("|", FALSE, BYROW(operandRows, REPLACE_BY_MASK)),

    // Split the operand strings out into a 2D array
    operands, TEXTSPLIT(delimitedString, "#", "|"),

    // Computes the result of one problem. Uses 'operators' and 'operands' from above.
    COMPUTE_COL, LAMBDA(colIndex,
        LET(
            // Index into 'operators' and 'operands' to get this problem
            operator, INDEX(operators, 1, colIndex),
            eqnOperands, CHOOSECOLS(operands, colIndex),

            // Split each operand (row) into a char array, transpose, then concatenate each row.
            transposedOperands, NUMBERVALUE(BYROW(
                TRANSPOSE(MID(
                    eqnOperands,
                    SEQUENCE(1, MAX(LEN(eqnOperands))),
                    1
                )),
                CONCAT
            )),

            IF(operator = "+",
                SUM(transposedOperands),
                PRODUCT(transposedOperands)
            )
        )
    ),

    // Solve all the problems separately and sum their results
    SUM(MAP(SEQUENCE(1, problemCount), COMPUTE_COL))
)
```


Day 07
===================================================================================================================================

Part 1: Straightforward enough. Generally trying to use ints instead of bools now since there's no element-wise AND/OR. Spent some
         time polishing this up after seeing the part 2 problem.

Part 2: Works by following the beams back up, with a count of how many timelines are in each beam. Splitters become adders.


Commented part 2:

```
=LET(
    input, A1:A142,
    rowChars, LEN(INDEX(input, 1)),

    // First input row giving the beam source
    inputBeams, MID(CHOOSEROWS(input, 1), SEQUENCE(1, rowChars), 1) = "S",

    // Select only the input rows with splitters
    inputSplitterRows, MID(CHOOSEROWS(input, SEQUENCE(1, (ROWS(input) - 1)/2, 3, 2)), SEQUENCE(1, rowChars), 1),
    
    // Shift an array to the right or left, dropping any elements shifted out of range and padding with 'pad'
    HSHIFT, LAMBDA(M,n,pad,
        IF(n = 0,
            M,
            IF(n > 0,
                HSTACK(IF(SEQUENCE(1, n, 1, 0), pad), DROP(M, 0, -n)),
                HSTACK(DROP(M, 0, -n), IF(SEQUENCE(1, -n, 1, 0), pad))
            )
        )
    ),
    
    // For a given set of input beams and splitter network, calculate how many timelines each beam splits into.
    COMPUTE_TIMELINES, LAMBDA(ME,beams,splitterRows,
        LET(

            // All spliters in this row
            row, CHOOSEROWS(splitterRows, 1) = "^",

            // Row of 1 or 0 representing whether there is a splitter with a beam going into it at each position.
            activeSplitters, beams * row,

            // Count the number of active splitters in the row - this was used in part 1
            activeSplitterCount, SUM(IF(activeSplitters, 1, 0)),

            // Beams which pass through without hitting a splitter
            passThroughs, beams * NOT(row),

            // Next beams come from splitters or passThroughs
            newBeams, (HSHIFT(activeSplitters, 1, 0) + HSHIFT(activeSplitters, -1, 0) + passThroughs) > 0,

            // If there are more rows of spliter to come, recurse.
            upBeams, IF(ROWS(splitterRows) > 1,
                ME(ME, newBeams, DROP(splitterRows, 1)),
                IF(newBeams, 1, 0)
            ),
            
            // Follow the beams back up, keeping track of how many timelines exist in each beam.
            // Splitters add the number of timelines in each beam below them, and passThroughs still do just that.
            (HSHIFT(upBeams, 1, 0) + HSHIFT(upBeams, -1, 0)) * activeSplitters + upBeams * passThroughs
        )
    ),
    
    // Find the number of timelines for the source beam.
    // The top-level recursion result should just have 1 value at the source location surrounded by zero
    SUM(COMPUTE_TIMELINES(COMPUTE_TIMELINES, inputBeams, inputSplitterRows))
)
```
