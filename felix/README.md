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

To avoid the recursion limit, two list elements are handled in each call. A similar technique is used in d1p2.
