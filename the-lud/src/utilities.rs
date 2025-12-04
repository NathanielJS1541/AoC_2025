use std::fs::File;
use std::io::BufReader;
use std::path::Path;

/*  Runs through a file line-by-line, running a callback function for each line parsed.
 */
pub fn do_line_by_line<T, F>(initial: T, filename: &Path, mut callback: F) -> std::io::Result<T>
where
    F: FnMut(T, &str) -> T,
{
    use std::io::BufRead;

    let file = File::open(filename)?;
    let reader = BufReader::new(file);
    let mut value = initial;
    for line in reader.lines() {
        let line = line?;
        value = callback(value, &line);
    }

    Ok(value)
}
