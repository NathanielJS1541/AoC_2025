use std::env;
use std::path::Path;

fn get_input_string() -> String {
    let args: Vec<String> = env::args().collect();

    let sample = Path::new("src/sample.txt");
    let input = Path::new("src/input.txt");
    let mut file: &Path = sample;

    if args.len() > 1 && &args[1] == "sample" {
        println!("Using sample.txt");
    } else {
        println!("Using input.txt");
        file = input;
    }

    let content =
        std::fs::read_to_string(file.to_str().unwrap()).expect("Failed to read input file");
    return content;
}

fn main() {
    let input: String = get_input_string();
    let mut current_pos: i64 = 50;
    let mut prev_pos: i64 = 50;
    let mut passes: i64 = 0;
    let mut zeros: i64 = 0;

    for line in input.lines() {
        let direction: char = line.as_bytes()[0] as char;
        let mut value: i64 = (&line[1..line.as_bytes().len()])
            .parse()
            .expect("Not a valid number");

        if value > 100 {
            passes += value / 100;
            value %= 100;
        }

        if direction == 'L' {
            value *= -1;
        }

        current_pos += value;

        if current_pos < 0 {
            if prev_pos % 100 != 0 {
                passes += 1;
            }
            current_pos = 100 + current_pos;
        }

        if current_pos >= 100 {
            current_pos -= 100;
            if current_pos % 100 != 0 {
                passes += 1;
            }
        }

        if current_pos == 0 {
            zeros += 1;
        }
        prev_pos = current_pos;
    }

    println!("Zeroes {}", zeros);
    println!("Passes {}", passes + zeros);
}
