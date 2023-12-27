open Util

let rec digits l acc =
    match l with
    | ('0' .. '9' as n) :: rest ->
        digits rest @@ ((int_of_char n - int_of_char '0') :: acc)
    | 'o' :: ('n' :: 'e' :: _ as rest) -> digits rest @@ (1 :: acc)
    | 't' :: ('w' :: 'o' :: _ as rest) -> digits rest @@ (2 :: acc)
    | 't' :: ('h' :: 'r' :: 'e' :: 'e' :: _ as rest) -> digits rest @@ (3 :: acc)
    | 'f' :: ('o' :: 'u' :: 'r' :: _ as rest) -> digits rest @@ (4 :: acc)
    | 'f' :: ('i' :: 'v' :: 'e' :: _ as rest) -> digits rest @@ (5 :: acc)
    | 's' :: ('i' :: 'x' :: _ as rest) -> digits rest @@ (6 :: acc)
    | 's' :: ('e' :: 'v' :: 'e' :: 'n' :: _ as rest) -> digits rest @@ (7 :: acc)
    | 'e' :: ('i' :: 'g' :: 'h' :: 't' :: _ as rest) -> digits rest @@ (8 :: acc)
    | 'n' :: ('i' :: 'n' :: 'e' :: _ as rest) -> digits rest @@ (9 :: acc)
    | _ :: rest -> digits rest acc
    | [] -> acc

let rec last = function
| [] -> failwith "no elements"
| [ x ] -> x
| _ :: xs -> last xs

let run file =
    let input = read_input file in
    let f acc x =
        let d = digits (explode x) [] in
        let l = last d in
        let r = last @@ List.rev d in
        acc + (10 * l) + r
    in
    let total = List.fold_left f 0 @@ List.rev input in
    print_endline @@ string_of_int total
