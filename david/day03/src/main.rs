fn main() {
    // Read input string from file
    let input : String = std::fs::read_to_string("src/input.txt").expect("Failed to read file");

    // Stores running total
    let mut sum : u64 = 0;

    // For each line in string
    for line in input.lines() {

        // Convert string to vec<u8>
        let list : Vec<u8> = line.as_bytes().into_iter().map(|x| x - 48).collect();

        let mut first : bool = true;
        let mut digits : Vec<u8> = Vec::new();
        let mut start_pos = 0;

        while digits.len() < 2 {
            // Find the location of the largest digit
            let mut max: u8 = 0;
            let mut max_index = 0;

            for (index, &x) in list.iter().enumerate() {
                // Don't look at indices before the start position
                if !first && (index <= start_pos) { continue; }
                
                // If this is the first digit, we don't want to look at the end!
                if first && (index == list.len() - 1) {
                    break; 
                }
                
                // Assign position and value
                if x > max {
                    max = x;
                    max_index = index;
                }
            }

            digits.push(max);
            start_pos = max_index;
            first = false;
        }

        // Assemble value
        let value : u64 = (digits[0] * 10 + digits[1]).into();
        sum += value;

        // Display digit
        println!("{}", value);
    }

    println!("TOTAL: {}", sum);
}
