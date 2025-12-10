/*  Observations
 *  Part two:
 *  We only have to recalculate the portion of the summed-area table (integral image) that has
 *  been altered. The brute force runtime isn't that long though so leave for another day.
 */

#[allow(unused_parens)]
use std::path::Path;
use crate::utilities::{convert_input_into_matrix, create_summed_area};
use std::collections::HashMap;

fn solvep1(matrix: &mut Vec<Vec<u8>>) -> i64
{
    let summed = create_summed_area(matrix.clone());

    let mut removable = 0;

    for (x, r) in summed.iter().enumerate()
    {
        for (y, c) in r.iter().enumerate()
        {
            if (matrix[x][y] == 1) && (*c < 4)
            {
                removable += 1;
            }
        }
    }

    return removable;
}

fn solvep2(matrix: &mut Vec<Vec<u8>>) -> i64
{
    let mut removed = 0;

    'main: loop
    {
        let summed = create_summed_area(matrix.clone());

        for (x, r) in summed.iter().enumerate()
        {
            for (y, c) in r.iter().enumerate()
            {
                if (matrix[x][y] == 1) && (*c < 4)
                {   // Remove it and recalculate.
                    matrix[x][y] = 0;
                    removed += 1;
                    continue 'main;
                }
            }
        }

        break;
    }

    return removed;
}

fn run_solve(problem_filepath: &Path, part: u8) -> i64
{
    let mut char_map : HashMap<char, u8> = HashMap::new();
    char_map.insert('@', 1);
    char_map.insert('.', 0);
    let mut matrix = convert_input_into_matrix(problem_filepath, Some(char_map));

    match (part)
    {
        1 => { return solvep1(&mut matrix); }
        2 => { return solvep2(&mut matrix); }
        _ => { return -1; }
    }
}

pub fn solution(problem_data_fp: &Path) {
    println!("d2p1: {}", run_solve(problem_data_fp, 1));
    println!("d2p2: {}", run_solve(problem_data_fp, 2));
}
