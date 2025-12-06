let in_file = "test_input"

type parser_state = {
  input: string;
  col_num: int;
  pos: int;
  cols: int list list;
  operators: string list;
}

let rec parse_input state =
  0
and parse_digit state =
  0

let day6_part1 input = parse_input {
  input = input;
  col_num = 0;
  pos = 0;
  cols = [];
  operators = [];
}

let day6_part2 input = 0

let day6 =
  let input = In_channel.with_open_text in_file In_channel.input_all in
  let answer1 = day6_part1 input in
  let answer2 = day6_part2 input in
  Printf.printf "Part 1 answer: %d\nPart 2 answer: %d\n" answer1 answer2

let () = day6
