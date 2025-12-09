/*  Observations:
 *  Part two:
 *  The solution is found when we find a value larger than our head node and there's exactly n
 *  elements left in the list where (n == length given by the caller.) In part two this is 12,
 *  but this could extend to any number <= the length of the input string.
 */
use std::collections::LinkedList;
use std::path::Path;
use crate::utilities::{do_line_by_line, concat_digits};

fn solve(sum : u64, battery_bank: &str, num_batteries: usize) -> u64
{
    let len = battery_bank.len();
    if (len <= num_batteries)
    {   // The solution has to be the full sequence as we can't pick-and-choose and end up with a
        // value larger than the full sequence.
        return sum + battery_bank.parse::<u64>().unwrap_or(0);
    }

    const DEFAULT: u8 = 0;
    let mut list: LinkedList<u8> = LinkedList::new();
    let mut bytes = battery_bank.as_bytes().iter();

    for i in 0..len
    {
        let byte = bytes.next().unwrap();

        // The observed byte is greater than the head and we've got enough elements left to form
        // a full sequence.
        if (((len - i) > num_batteries) && (byte > list.front().unwrap_or(&DEFAULT)))
        {
            // Either the input value is the largest we've detected so far or the list is empty.
            // In either case, we place this at the head and pop-off the remainder of the list.
            //  e.g. 3 => (3) ->
            //  e.g. 7 => (7) -/-> (6) -> (4) => (7) ->
            // Don't do this if we're looking at the last value in the list.
            list.push_front(*byte); // Push the new head.
            list.split_off(1); // Pop off the rest of the list.
        }
        else
        {   // Iterate over the rest of the stored nodes to see if we need to replace them.
            // To avoid double mutable borrow, collect indices to replace, then do mutation after
            // iteration.
            let mut replace_idx: Option<usize> = None;
            for (idx, item) in list.iter().skip(1).enumerate()
            {
                if ((byte > item) && ((len - i) >= (num_batteries - (idx + 1))))
                {   // Our input is larger than our node and we have enough items left in the
                    // sequence to fill the rest of the list.
                    replace_idx = Some(idx + 1); // +1 because we skipped the head.
                    break;
                }
            }

            if let Some(idx) = replace_idx {
                // Remove all elements from idx onward, then push_back the new byte
                list.split_off(idx);
                list.push_back(*byte);
            }
            else if (list.len() < num_batteries)
            {   // No items were added and we have space for the item, add it to the end.
                list.push_back(*byte);
            }
        }

    }

    // Convert the list to a Vec<u8> of digits, then to a number
    let list_as_vec: Vec<u8> = list.iter().map(|v| v.saturating_sub(48)).collect();
    let value = concat_digits(&list_as_vec).unwrap_or(0);

    return sum + value;
}

fn solvep1(problem_filepath: &Path) -> u64
{
    let mut sum: u64 = 0;
    sum = do_line_by_line(  sum,
                            problem_filepath,
                            |v, line| solve(v, line, 2))
            .expect("Failed to process lines");
    return sum;
}

fn solvep2(problem_filepath: &Path) -> u64
{
    let mut sum: u64 = 0;
    sum = do_line_by_line(  sum,
                            problem_filepath,
                            |v, line| solve(v, line, 12))
            .expect("Failed to process lines");
    return sum;
}

pub fn solution(problem_data_fp: &Path) {
    println!("d3p1: {}", solvep1(problem_data_fp));
    println!("d3p2: {}", solvep2(problem_data_fp));
}
