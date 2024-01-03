type 'a t = {
    mutable arr: 'a array;
    mutable size: int;
    mutable capacity: int;
}

let make n x = {
    arr = Array.make n x;
    size = 0;
    capacity = n;
}

let get t i =
    if i < 0 || i >= t.size then
        invalid_arg "index out of bounds"
    else
        Array.unsafe_get t.arr i

let set t i x =
    if i < 0 || i >= t.size then
        invalid_arg "index out of bounds"
    else
        Array.unsafe_set t.arr i x

let add t x =
    if t.size = t.capacity then
        let new_capacity = t.capacity * 2 in
        let new_arr = Array.make new_capacity x in
        Array.blit t.arr 0 new_arr 0 t.size;
        t.arr <- new_arr;
        t.capacity <- new_capacity;
    else
        Array.unsafe_set t.arr t.size x;
    t.size <- t.size + 1

let find_opt f t =
    let rec aux i =
        if i = t.size then
            None
        else
            let x = Array.unsafe_get t.arr i in
            if f x then
                Some x
            else
                aux (i + 1)
    in
    aux 0

let find_index f t =
    let rec aux i =
        if i = t.size then
            None
        else
            let x = Array.unsafe_get t.arr i in
            if f x then
                Some i
            else
                aux (i + 1)
    in
    aux 0

let remove t i =
    if i < 0 || i >= t.size then
        invalid_arg "index out of bounds"
    else
        let x = Array.unsafe_get t.arr i in
        Array.blit t.arr (i + 1) t.arr i (t.size - i - 1);
        t.size <- t.size - 1;
        x

let iter f t =
    for i = 0 to t.size - 1 do
        f (Array.unsafe_get t.arr i)
    done

let iteri f t =
    for i = 0 to t.size - 1 do
        f i (Array.unsafe_get t.arr i)
    done
