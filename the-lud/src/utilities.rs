#[allow(unused_parens)]
use std::fs::{self, File};
use std::io::{BufRead, BufReader, Result};
use std::path::Path;
use std::collections::HashMap;
use std::cmp::{min, max};
use divisors;  // https://docs.rs/divisors/latest/src/divisors/lib.rs.html#1-113

/// Runs through a file line-by-line, running a callback function for each line parsed.
pub fn do_line_by_line<T, F>(initial: T, filename: &Path, mut callback: F) -> Result<T>
where
    F: FnMut(T, &str) -> T,
{
    let file = File::open(filename)?;
    let reader = BufReader::new(file);
    let mut value = initial;
    for line in reader.lines() {
        let line = line?;
        value = callback(value, &line);
    }

    Ok(value)
}


/// Splits the entire contents of a file into segments on a seperator.
/// Each segment is given to the callback to perform some action.
/// The accumulated value of these actions is returned.
pub fn do_for_each_segment<T, F>(intial : T, filename: &Path, mut callback : F, seperator: char) -> Result<T>
where
    F: FnMut(T, &str) -> T,
{

    let contents = fs::read_to_string(filename).expect("Unable to read file");
    let mut value = intial;

    for segments in contents.split(seperator)
    {
        value = callback(value, &segments);
    }

    Ok(value)
}

/// A class that calculates all divisors of some value.
/// Note: This does not calculate the divisors on construction.
pub struct Divisor
{
    cache: HashMap<u64, Vec<u64>>
}

impl Divisor
{
    pub fn new() -> Self
    {
        Self { cache: HashMap::new() }
    }

    pub fn get(&mut self, n: u64) -> Vec<u64>
        {
            match self.cache.get(&n)
            {
                Some(existing_vec) => { return existing_vec.to_vec(); },
                None =>
                {
                    let divisors_vec = divisors::get_divisors(n);
                    self.cache.insert(n, divisors_vec.clone());
                    return divisors_vec;
                }
            }
        }
}

pub fn concat_digits(digits: &[u8]) -> Option<u64>
{
    let mut n: u64 = 0;
    for &d in digits
    {
        if d > 9 { return None; }
        n = n.checked_mul(10)?.checked_add(d as u64)?;
    }
    return Some(n)
}

/// Read a file line-by-line and store each line as a row in a new matrix.
/// If the user has provided a mapping of characters -> u8 in `map_chars`, then write the converted
/// u8 to the matrix. Otherwise, treat the file as having digits and try to write these digits as
/// u8s to the matrix instead.
pub fn convert_input_into_matrix(filepath: &Path, map_chars: Option<HashMap<char, u8>>)
    -> Vec<Vec<u8>>
{
    let file = File::open(filepath).expect("Unable to read file");
    let reader = BufReader::new(file);

    // First, collect all lines to determine line count and max line length
    let lines: Vec<String> = reader.lines()
        .map(|line| line.expect("Unable to read line"))
        .collect();

    let line_count = lines.len();
    let line_length = lines.iter().map(|line| line.len()).max().unwrap_or(0);

    let mut matrix: Vec<Vec<u8>> = Vec::with_capacity(line_count);

    let map_chars_ref = map_chars.as_ref();

    for line in lines.iter()
    {
        let mut row: Vec<u8> = Vec::with_capacity(line_length);
        for ch in line.chars()
        {
            let val: u8;

            if let Some(m) = map_chars_ref.and_then(|m| m.get(&ch))
            {   // Caller gave us a mapping, if the chars are in the mapping, convert and use the
                // converted u8 value.
                val = *m;
            }
            else
            {   // Otherwise, assume we're handling digits and convert into a u8.
                val = ch.to_digit(10).map(|d| d as u8).unwrap_or(0);
            }

            row.push(val);
        }

        matrix.push(row);
    }

    return matrix;
}

#[allow(unused_parens)]
/// Return the sum of all (up to) eight adjacent cells surrounding a centre point, ignoring the
/// centre point in the calculation.
fn sum_inner_matrix(matrix: &Vec<Vec<u8>>, centre: (usize, usize)) -> u8
{
    let row_min = max(0, centre.0.saturating_sub(1));
    let row_max = min(centre.0 + 1, matrix.len() - 1);
    let col_min = max(0, centre.1.saturating_sub(1));
    let col_max = min(centre.1 + 1, matrix[0].len() - 1);
    let mut sum: u8 = 0;

    for r in row_min..=row_max
    {
        for c in col_min..=col_max
        {
            if ((r, c) == centre) { continue; }

            sum += matrix[r][c];
        }
    }

    return sum;
}

/// Creates an integral image (summed-area table) of an input matrix.
/// Assumes the matrix is always square and using u8 values.
/// This might need to change later but for now (day 4), this will do.
pub fn create_summed_area(matrix: Vec<Vec<u8>>)
    -> Vec<Vec<u8>>
{
    let height = matrix.len();
    let mut summed_matrix : Vec<Vec<u8>> = (0..height).map(|_| vec![0u8; height]).collect();

    for r in 0..height
    {
        for c in 0..height
       {
           summed_matrix[r][c] = sum_inner_matrix(&matrix, (r, c));
       }
    }

    return summed_matrix;
}
