use regex::Regex;

fn main() {
    // Read input string from file
    let input : String = std::fs::read_to_string("src/input.txt").expect("Failed to read file");

    // Expression has groups for the direction and the value
    let ex = Regex::new(r"([LR])(\d+)").unwrap();

    // Create a list of all matches
    let mut matches : Vec<(char, i32)> = Vec::new();
    for (_, [dir, val]) in ex.captures_iter(&input).map(|c| c.extract()) {
        matches.push((dir.parse::<char>().expect("Not a char"), val.parse::<i32>().expect("Not a number")));
    }

    // Keep track of current position, starts at 50
    let mut pos : i32 = 50;

    // Number of zeroes
    let mut zeroes : i32 = 0;
    let mut passes : i32 = 0;

    // Number of values in a full rotation
    let clicks : i32 = 100;

    // For each line in the input, parse and modify the value
    for instruction in matches {
        // Store the previous position
        let prev: i32 = pos;

        // Get the value from the list
        let mut value : i32 = instruction.1;

        // Passes due to sheer immensity
        passes += value / clicks;
        value %= clicks;

        // If going left, negate the value
        if instruction.0 == 'L' {
            value *= -1;
        }

        // Increment position
        pos += value;
        
        // Handle over&underflow, if not already handled by previous
        if (pos < 0 || pos > clicks) && prev != 0 {
            passes += 1;
        }

        // Constrain!
        if pos >= clicks { pos -= clicks; }
        if pos < 0       { pos += clicks; }

        // Land on exactly 0
        if pos == 0 {
            zeroes += 1;
        }

    }

    println!("Lands on zero: {}", zeroes);
    println!("Passes: {}", passes);
    println!("Total: {}", zeroes + passes);
}
