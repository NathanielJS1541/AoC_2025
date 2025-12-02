use std::fs;

//Rotation with direction and distance
struct Rotation {
    dir: String,
    dist: i32,
}

const STARTPOS: i32 = 50;
const LEFT: &str = "L";

fn main() {
    part1test();
    part1();
    part2test();
    part2();
}

fn part1() {
    let filename: String = "day1.txt".to_string();
    let contents = readfile(filename);
    println!("Part 1 Password: {}", calculatepassword(contents, true));
}

fn part1test() {
    let filename: String = "day1test.txt".to_string();
    let contents = readfile(filename);
    assert!(calculatepassword(contents, true) == 3);
}

fn part2() {
    let filename: String = "day1.txt".to_string();
    let contents = readfile(filename);
    println!("Part 2 Password: {}", calculatepassword(contents, false));
}

fn part2test() {
    let filename: String = "day1test.txt".to_string();
    let contents = readfile(filename);
    assert!(calculatepassword(contents, false) == 6);
}

fn calculatepassword(sequence: String, part1: bool) -> i32 {
    let mut current_pos: i32 = STARTPOS;
    let mut password: i32 = 0;

    //One instruction per line of sequence
    let instructions = sequence.split("\n");
    let mut rots = Vec::new();
    for instruction in instructions {
        //println!("{}", instruction);
        let (first, last) = instruction.split_at(1);
        let thisrot = Rotation {
            dir: first.to_string(),
            dist: last.trim().parse::<i32>().expect("PARSING ERROR"),
        };

        rots.push(thisrot);
    }

    for rot in rots {
        let start_pos = current_pos;
        let mut passedzero = false;
        let mut passedleft = false;
        //println!("{}{}", rot.dir.to_string(), rot.dist.to_string());
        //Subtract
        if rot.dir == LEFT.to_string() {
            current_pos -= rot.dist;
        }
        //Add
        else {
            current_pos += rot.dist;
        }

        //for part 2, increment password each time 0 is passed through
        if !part1 {
            //if negative or 0, and starting at greater than 0, add 1
            if current_pos <= 0 && start_pos > 0 {
                password += 1;
            }

            //for each time it has passed 100, add 1
            password += current_pos.abs() / 100;
        }

        while current_pos < 0 {
            current_pos = 100 + current_pos;
        }

        while current_pos >= 100 {
            current_pos -= 100;
        }

        //For part 1, increment password each time a move ends on 0
        if part1 {
            if current_pos == 0 {
                password += 1;
            }
        }

        //println!("Current position: {}", current_pos.to_string());
        //println!("Current password: {}", password.to_string());
    }

    return password;
}

fn readfile(filename: String) -> String {
    let mut filepath: String = "./inputs/".to_string();
    filepath.push_str(&filename);
    let contents = fs::read_to_string(filepath).expect("File not read");
    return contents;
}
