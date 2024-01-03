include Day15

let parse_input path =
    let chan = open_in path in
    let content = really_input_string chan (in_channel_length chan) in
    let () = close_in chan in
    String.split_on_char ',' @@ String.trim content

let hash =
    String.fold_left (fun acc c -> (acc + (Char.code c)) * 17 mod 256) 0

let part1 =
    List.fold_left (fun acc c -> (hash c) + acc) 0


module LensArray = struct
    let create () = Array.init 256 (fun _ -> Box.make 5 ("", 0))

    let add t label lens =
        let h = hash label in
        let b = Array.unsafe_get t h in
        let i = Box.find_index (fun (l, _) -> l = label) b in
        match i with
        | Some i -> Box.set b i (label, lens)
        | None -> Box.add b (label, lens)


    let remove t label =
        let h = hash label in
        let b = Array.unsafe_get t h in
        let i = Box.find_index (fun (l, _) -> l = label) b in
        match i with
        | Some i -> Box.remove b i |> ignore
        | None -> ()

    let focusing_power t =
        let total = ref 0 in
        Array.iteri (fun i a  ->
            Box.iteri (fun j (_, lens) ->
                total := !total + (i + 1) * (j + 1) * lens
            ) a
        ) t;
        !total
end

let part2 commands =
    let lenses = LensArray.create () in
    let apply_command command =
        if String.ends_with ~suffix:"-" command then
            let label = String.sub command 0 (String.length command - 1) in
            LensArray.remove lenses label
        else
            let parts = String.split_on_char '=' command in
            let label = List.nth parts 0 in
            let lens = List.nth parts 1 |> int_of_string in
            LensArray.add lenses label lens
    in
    let rec loop commands =
        match commands with
        | [] -> ()
        | (x::xs) ->
            apply_command x;
            loop xs;
    in
    loop commands;
    LensArray.focusing_power lenses


let () =
    let commands = parse_input "input/input.txt" in
    Printf.printf "Part 1: %d\n" @@ part1 commands;
    Printf.printf "Part 2: %d\n" @@ part2 commands

