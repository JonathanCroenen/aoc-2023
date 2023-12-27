
let read_input path =
    let chan = open_in path in
    let rec loop buf =
        let line = input_line chan in
        let buf = line :: buf in
        try loop buf with End_of_file -> buf
    in
    loop []

let explode s =
    let rec exp i l = if i < 0 then l else exp (i - 1) (s.[i] :: l) in
    exp (String.length s - 1) []
