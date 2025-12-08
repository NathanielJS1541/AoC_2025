#[allow(unused_parens)]
use std::fs::{self, File};
use std::io::{BufRead, BufReader, Result};
use std::path::Path;
use std::collections::HashMap;
use divisors;

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
