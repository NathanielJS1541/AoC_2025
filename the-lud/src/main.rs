mod days {
    pub mod day1;
    pub mod day2;
}

mod utilities;

use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() < 2 {
        eprintln!("Usage: {} <day_number>", args[0]);
        return;
    }

    match args[1].as_str() {
        "1" => days::day1::solution(std::path::Path::new("./inputs/day1.txt")),
        "2" => days::day2::solution(),
        _ => eprintln!(
            "This day has not been completed, or does not exist: {}",
            args[1]
        ),
    };
}
