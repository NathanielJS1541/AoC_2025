/*
Help me i'm addicted to regular expressions
*/

use regex::Regex;

fn main() {
    // Read input string from file
    let input : String = std::fs::read_to_string("src/input.txt").expect("Failed to read file");

    // Expression has groups for the start and end of each range
    let ex = Regex::new(r"(\d+)-(\d+)").unwrap();

    // Create a list of all matches
    let mut matches : Vec<(u64, u64)> = Vec::new();
    for (_, [start, end]) in ex.captures_iter(&input).map(|c| c.extract()) {
        matches.push((start.parse::<u64>().expect("Not a number"), end.parse::<u64>().expect("Not a number")));
    }

    // Total of invalid IDs
    let mut sum1 : u64 = 0;
    let mut sum2 : u64 = 0;

    // Loop through each match
    for range in matches {
        
        // Loop through each ID in that range (including end value)
        for id in range.0 .. (range.1 + 1) {
            let str_id : String = id.to_string();
            let vec_id : Vec<u8> = str_id.as_bytes().to_vec();

            let len = vec_id.len();

            // Part 1
            // An ID with an odd length can't be a duplicated sequence
            if len % 2 != 1 {

                // If the first half is equal to the second half,
                if vec_id[0 .. len/2] == vec_id[len/2 .. len] {
                    sum1 += id;
                }
            }

            // Part 2
            // Default to invalid
            let mut invalid : bool = false;

            // For each potential substring length
            for len_substr in 1 .. (len/2 + 1) {

                // Break vector into equal-sized chunks
                let chunks : Vec<&[u8]> = vec_id.chunks(len_substr).collect();

                // Default to matching
                let mut all_match : bool = true;
                // The string is invalid if all the chunks are equal
                for i in 0 .. chunks.len() {
                    if chunks[0] != chunks[i] { all_match = false; break; }
                }

                if all_match { invalid = true; break; }
            }

            // Add to total
            if invalid { 
                println!("Invalid id: {}", str_id);
                sum2 += id; 
            }

        }
    }

    println!("\n\n");
    println!("Part 1: {}", sum1);
    println!("Part 2: {}", sum2);
}
