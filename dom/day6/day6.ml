let in_file = "test_input"

type expr = Plus | Multiply
type token = Num of char | Expr of expr | Whitespace | Newline | End

type parser_state = {
  input : string;
  col_num : int;
  pos : int;
  cols : int list array;
  operators : expr list;
  number : string;
}

let parse_next_char st =
  if st.pos < String.length st.input then
    let c = String.get st.input st.pos in
    match c with
    | '0' .. '9' -> Num c
    | '+' -> Expr Plus
    | '*' -> Expr Multiply
    | ' ' -> Whitespace
    | '\n' -> Newline
    | _ -> raise (Failure ("Bad input:" ^ Char.escaped c))
  else End

let debug_col st number =
  let col = Array.get st.cols st.col_num in
    let len = List.length col in
    Printf.printf "%d + %d\n" (List.nth col (len - 1)) number

let finish_number st col_num =
  let number = int_of_string st.number in
  if st.col_num >= Array.length st.cols then (
    let cols = Array.append st.cols [| [ number ] |] in
    { st with number = ""; pos = st.pos + 1; col_num; cols })
  else
    let head = Array.sub st.cols 0 st.col_num
    and tail = Array.sub st.cols st.col_num (Array.length st.cols - st.col_num)
    and col = List.append st.cols.(st.col_num) [ number ] in
    debug_col st number;
    let cols = Array.concat [ head; [| col |]; tail ] in
    { st with number = ""; pos = st.pos + 1; col_num; cols }

let rec parse_line st =
  let token = parse_next_char st in
  match token with
  | Num c ->
      parse_number
        { st with pos = st.pos + 1; number = st.number ^ Char.escaped c }
  | Expr e ->
      parse_line
        {
          st with
          pos = st.pos + 1;
          operators = st.operators @ [ e ];
          col_num = st.col_num + 1;
        }
  | Whitespace -> parse_line { st with pos = st.pos + 1 }
  | Newline -> parse_line { st with pos = st.pos + 1; col_num = 0 }
  | End -> st

and parse_number st =
  let token = parse_next_char st in
  match token with
  | Num c ->
      parse_number
        { st with pos = st.pos + 1; number = st.number ^ Char.escaped c }
  | Expr e ->
      parse_line
        {
          st with
          pos = st.pos + 1;
          operators = st.operators @ [ e ];
          col_num = st.col_num + 1;
        }
  | Whitespace -> parse_line (finish_number st (st.col_num + 1))
  | Newline -> parse_line (finish_number st 0)
  | End -> st

let day6_part1 input =
  let state =
    parse_line
      { input; col_num = 0; pos = 0; cols = [||]; operators = []; number = "" }
  in
  Printf.printf "pos: %d\n" (List.fold_left ( + ) 0 state.cols.(1));
  0

let day6_part2 input = 0

let day6 =
  let input = In_channel.with_open_text in_file In_channel.input_all in
  let answer1 = day6_part1 input in
  let answer2 = day6_part2 input in
  Printf.printf "Part 1 answer: %d\nPart 2 answer: %d\n" answer1 answer2

let () = day6
