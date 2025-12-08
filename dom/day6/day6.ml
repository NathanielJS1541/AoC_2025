let in_file = "input"

type expr = Plus | Multiply
type token = Num of char | Expr of expr | Whitespace | Newline | End

type parser_state = {
  input : string;
  col_num : int;
  pos : int;
  cols : int list iarray;
  operators : expr list;
  number : string;
  in_num : bool;
  answers : int list;
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

let debug_col st number col_num =
  Printf.printf "Col 0: [";
  List.iter (Printf.printf "%d, ") (Iarray.get st.cols 0);
  Printf.printf "]\nCol 1: [";
  List.iter (Printf.printf "%d, ") (Iarray.get st.cols 1);
  Printf.printf "]\nCol 2: [";
  List.iter (Printf.printf "%d, ") (Iarray.get st.cols 2);
  Printf.printf "]\nCol 3: [";
  List.iter (Printf.printf "%d, ") (Iarray.get st.cols 3);
  Printf.printf "]\n"

let finish_number st col_num =
  let number = int_of_string st.number in
  if st.col_num >= Iarray.length st.cols then
    let cols = Iarray.append st.cols [| [ number ] |] in
    { st with number = ""; pos = st.pos + 1; in_num = false; col_num; cols }
  else
    let add_num = fun i li -> if i = st.col_num then li @ [ number ] else li in
    let cols = Iarray.mapi add_num st.cols in
    (*debug_col st number col_num; *)
    { st with number = ""; pos = st.pos + 1; in_num = false; col_num; cols }

let rec parse_line st =
  let token = parse_next_char st in
  match token with
  | Num c ->
      parse_line
        {
          st with
          pos = st.pos + 1;
          number = st.number ^ Char.escaped c;
          in_num = true;
        }
  | Expr e ->
      let answer =
        match e with
        | Plus -> List.fold_left ( + ) 0 (Iarray.get st.cols st.col_num)
        | Multiply -> List.fold_left ( * ) 1 (Iarray.get st.cols st.col_num)
      in
      parse_line
        {
          st with
          pos = st.pos + 1;
          operators = st.operators @ [ e ];
          col_num = st.col_num + 1;
          answers = st.answers @ [ answer ];
        }
  | Whitespace ->
      let new_st =
        if st.in_num then finish_number st (st.col_num + 1)
        else { st with pos = st.pos + 1 }
      in
      parse_line new_st
  | Newline ->
      let new_st =
        if st.in_num then finish_number st 0
        else { st with pos = st.pos + 1; col_num = 0 }
      in
      parse_line new_st
  | End -> st

let day6_part1 input =
  let state =
    parse_line
      {
        input;
        col_num = 0;
        pos = 0;
        cols = [||];
        operators = [];
        number = "";
        in_num = false;
        answers = [];
      }
  in
  (* List.iter (Printf.printf "%d, ") state.answers; *)
  List.fold_left ( + ) 0 state.answers

let day6_part2 input = 0

let day6 =
  let input = In_channel.with_open_text in_file In_channel.input_all in
  let answer1 = day6_part1 input in
  let answer2 = day6_part2 input in
  Printf.printf "Part 1 answer: %d\nPart 2 answer: %d\n" answer1 answer2

let () = day6
