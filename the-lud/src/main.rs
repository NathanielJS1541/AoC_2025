#[allow(unused_parens)]
mod days {
    pub mod day1;
    pub mod day2;
    pub mod day3;
    pub mod day4;
}

mod utilities;

use std::env;
use std::path::Path;

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() < 2 {
        eprintln!("Usage: {} <day_number>", args[0]);
        return;
    }

    match args[1].as_str() {
        "1" => days::day1::solution(Path::new("./inputs/day1.txt")),
        "2" => days::day2::solution(Path::new("./inputs/day2.txt")),
        "3" => days::day3::solution(Path::new("./inputs/day3.txt")),
        "4" => days::day4::solution(Path::new("./inputs/day4.txt")),
        _ => eprintln!(
            "This day has not been completed, or does not exist: {}",
            args[1]
        ),
    };
}
