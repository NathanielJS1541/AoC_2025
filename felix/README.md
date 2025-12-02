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
