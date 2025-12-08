/*
 * Observations:
 *  Part one -
 *  The number of digits is important. For the same digit to appear twice, the total number of
 *  digits in a sequence must be divisible-by-two (%2 != 0).
 *  The requirement simply states that "invalid IDs [are].. made only of some sequence of digits
 *  repeated twice". The "only" is important, as this means that the number of digits in an
 *  invalid id has a length half the total length of the sequence.
 *  It doesn't state whether the "given ranges" are duplicated/overlapping such that we will
 *  be double counting invalid ids or not.
 *
 *  Part two -
 *  Same observations as above except that the digit sequence can repeat any number of times.
 *  In pattern of digits must repeat some number of times that is divisible by the total length.
 *  e.g.
 *  Seq.       len  capture_group size
 *  1111 =>     4,          1
 *  1010 =>     4,          2
 *  110  =>     3           2
 *  This means that all sequences with a number of digits that is a power-of-two do not need any
 *  extra treatement, the sequence must be a mirror image (e.g. 2121|2121) even if the sequence
 *  contains greater than two repeated sequence. We handled this in part one.
 *  Sequences of other lengths must be broken down further.
 */

#[allow(unused_parens)]
use crate::utilities::Divisor;
use crate::utilities::do_for_each_segment;
use std::path::Path;
use std::collections::HashMap;

static mut PART : u8 = 0;

/// Check that a number of string segments (as a byte array) are equal.
/// Takes a string (digits) and a unsigned-size (n_segments) which determines into how many
/// parts the string will be split before checking each segment against each other segment.
///
/// An input of n_segments == digits.len() will check that all of the characters are equal.
/// This is required when the length of the string is not divisible (len is a prime number).
fn check_segments_are_identical(digits: &str, n_segments: usize) -> bool
{
    let mut result = false;
    let len = digits.len();

    if (digits.is_empty() || ((len % n_segments) != 0))
    {
        return result;
    }

    // Again, we can just use the byte array as we're using ASCII here.
    let n_chunks = len / n_segments;

    let mut chunks = digits.as_bytes().chunks_exact(n_chunks);

    let first = match chunks.next() { Some(c) => c, None => return false };

    result = ((chunks.all(|c| c == first) && (chunks.remainder().is_empty())));

    return result;
}

/// Solves part two.
/// Checks for any number of repetitions of digits by subdividing the string as many ways
/// as possible, checking each permutation for validity before caching it.
fn check_for_any_repeats(digits: &str,
                        result_cache: &mut HashMap<String, bool>,
                        div_cache: &mut Divisor) -> bool
{
    let mut is_invalid = false;

    match result_cache.get(digits) {
        Some(&is_invalid) => {
            return is_invalid;
        }
        _ => (),
    }

    let len = digits.len();

    if (len < 2)
    {   // We need at least two characters to get a repeat, duh.
        return false;
    }

    // See how many different permutations that the string can be sub-divided into.
    let divs = div_cache.get(len as u64);

    if (divs.len() == 0)
    {   // Length is prime. Check to see if the entire string is equal (e.g. 1111111).
        is_invalid = check_segments_are_identical(digits, digits.len());
    }
    else
    {   // Check the input in segments of descending size.
        // e.g. "12341234" => 1234 1234
        //                    12 34 12 34
        for div in &divs
        {
            if (check_segments_are_identical(digits, *div as usize))
            {
                is_invalid = true;
                break;
            }
        }
    }

    if (is_invalid)
    {
        result_cache.insert(digits.to_string(), is_invalid);
    }

    return is_invalid;
}

/// Solves part one. Check two halves of a string are equal, caching the result.
fn check_for_invalid_id(digits: &str, cache: &mut HashMap<String, bool>) -> bool
{
    let mut is_invalid = false;

    match cache.get(digits) {
        Some(&is_invalid) => {
            return is_invalid;
        }
        _ => (),
    }

    let length = digits.len(); // Actually the byte-length but we're doing ASCII-tings.

    if (length % 2 == 0)
    {
        let (first, second) = digits.split_at(length / 2);

        // Check both segments are the same.
        is_invalid = (first == second);

        if (is_invalid) {
            cache.insert(digits.to_string(), is_invalid);
        }
    }

    return is_invalid;
}

/// Main solution code - converts an input range string into a start and end value then
/// iterates between them checking each intermediate value for validity.
fn check_for_invalid_ids(value: i64, range: &str, cache: &mut HashMap<String, bool>) -> i64
{
    let mut sum = value;
    let parts: Vec<&str> = range.split('-').collect();
    if parts.len() != 2 {
        return sum;
    }
    let start = parts[0].parse::<i64>().unwrap();
    let end = parts[1].parse::<i64>().unwrap();
    let mut div_cache : Divisor = Divisor::new();

    for n in start..(end+1)
    {
        let n_str = n.to_string();

        unsafe
        {
            match (PART)
            {
                1 =>
                {
                    if (check_for_invalid_id(n_str.as_str(), cache))
                    {
                        sum += n_str.parse::<i64>().unwrap();
                    }
                },
                2 =>
                {
                    if (check_for_any_repeats(n_str.as_str(), cache, &mut div_cache))
                    {
                        sum += n_str.parse::<i64>().unwrap();
                    }
                },
                _ => {
                    eprint!("Invalid part given");
                }
            }
        }
    }

    return sum;
}

fn solve(problem_filepath: &Path) -> i64
{
    let mut cache = HashMap::<String, bool>::new();

    let mut value: i64 = 0;
    let seperator: char = ',';
    value = do_for_each_segment(
        value,
        problem_filepath,
        |v, segment| check_for_invalid_ids(v, segment, &mut cache),
        seperator,
    )
    .expect("Failed to process lines");

    return value;
}

fn solvep1(problem_filepath: &Path) -> i64
{
    unsafe { PART = 1; }
    return solve(problem_filepath);
}

fn solvep2(problem_filepath: &Path) -> i64
{
    unsafe { PART = 2; }
    return solve(problem_filepath);
}

pub fn solution(problem_data_fp: &Path) {
    println!("d2p1: {}", solvep1(problem_data_fp));
    println!("d2p2: {}", solvep2(problem_data_fp));
}
