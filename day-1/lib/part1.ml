open Util

let rec digits = function
| ('0' .. '9' as n) :: _ -> int_of_char n - int_of_char '0'
| _ :: rest -> digits rest
| [] -> failwith "no digits found"

let run file =
    let input = read_input file in
    let total =
        List.fold_left
          (fun acc x ->
            let l = digits @@ explode x in
            let r = digits @@ List.rev @@ explode x in
            acc + (l * 10) + r)
          0
        @@ List.rev input
    in
    print_endline @@ string_of_int total
