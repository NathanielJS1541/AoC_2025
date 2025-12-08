#[allow(unused_parens)]
/*  DAY 1
 *  SECRET ENTRANCE
 *
 *  Dial rotates from 0-99.
 *  Directions show how to rotate: L for left, R for right, followed by a number from 0 to 99.
 *  The dial starts pointing at 50.
 *
 *  In part one, the solution is the number of times the dial stops on zero.
 *  In part two, the solution is the number of times the dial passes through or stops on zero.
 */

use crate::utilities::do_line_by_line;
use std::path::Path;

static mut POSITION: i32 = 50;

fn rotate_dial(value: i32, line: &str, count_each: bool) -> i32
{
    let rot_dir = line.chars().next().expect("No direction given");
    let rot_n: i32 = line[1..].trim().parse().expect("No rotational value given");
    let mut new_position: i32;
    let mut n_zeroes: i32 = value;

    match rot_dir
    {
        'R' => unsafe {
            new_position = POSITION
                .checked_sub(rot_n)
                .expect("Underflow in right rotation");
        },
        'L' => unsafe {
            new_position = POSITION
                .checked_add(rot_n)
                .expect("Overflow in left rotation");
        },
        _ => panic!("Invalid rotation direction"),
    }

    // Part two only: Count each crossing of 0-boundary before we normalise the new position.
    if (count_each)
    {
        let zeroes = if new_position <= 0
            {
            let is_zeroed = unsafe { (!(POSITION == 0)) as i32 };
            // If we're rolling over into negative or zero, we have at least one zero plus
            // any further rollovers (groups of 100).
            is_zeroed + new_position.abs().checked_div(100).unwrap_or(0)
        }
        else {
            new_position.checked_div(100).unwrap_or(0)
        };

        n_zeroes = n_zeroes + zeroes;
    }

    // Normalise.
    new_position = new_position % 100;

     if (new_position < 0)
     {  // Apply rollover.
        new_position = 100 + new_position
     }

    unsafe { POSITION = new_position; }

    // Part one only: Count only when we land on 0.
    if ((new_position == 0) && (!count_each))
    {
        n_zeroes = n_zeroes + 1;
    }

    return n_zeroes;
}

fn solve(problem_data_fp: &Path, part: u8) -> i32
{
    let check_all_zeroes = (part == 2);
    unsafe { POSITION = 50; }
    let mut value = 0;
    value = do_line_by_line( value,
                            problem_data_fp,
                            |v, line| rotate_dial(v, line, check_all_zeroes))
            .expect("Failed to process lines");
    return value;
}

fn solvep1(problem_data_fp: &std::path::Path) -> i32
{
    return solve(problem_data_fp, 1);
}

fn solvep2(problem_data_fp: &std::path::Path) -> i32
{
    return solve(problem_data_fp, 2);
}

pub fn solution(problem_data_fp: &Path)
{
    println!("d1p1: {}", solvep1(problem_data_fp));
    println!("d1p2: {}", solvep2(problem_data_fp));
}
