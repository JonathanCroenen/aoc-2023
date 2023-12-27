fn parse_input(path: &str) -> (Vec<u64>, Vec<Vec<(u64, u64, u64)>>) {
    let input = std::fs::read_to_string(path).unwrap();

    let seed_line_end = input.find('\n').unwrap();
    let seeds = input[7..seed_line_end]
        .split(" ")
        .map(|x| x.parse::<u64>().unwrap())
        .collect::<Vec<u64>>();

    let maps = input[seed_line_end + 2..]
        .split("\n\n")
        .map(|group| {
            let mut map = Vec::new();

            let mut iter = group.split("\n");
            let _ = iter.next().unwrap();

            for line in iter {
                if line.len() == 0 {
                    continue;
                }

                let mut iter = line.split(" ");
                let dest_start = iter.next().unwrap().parse::<u64>().unwrap();
                let source_start = iter.next().unwrap().parse::<u64>().unwrap();
                let len = iter.next().unwrap().parse::<u64>().unwrap();

                map.push((dest_start, source_start, len));
            }
            map
        })
        .collect::<Vec<Vec<(u64, u64, u64)>>>();

    (seeds, maps)
}

fn main() {
    let (seeds, maps) = parse_input("input/input.txt");

    let mut closest = u64::MAX;

    for seed in seeds {
        let mut current_id = seed;
        for map in &maps {
            for (dest_start, source_start, len) in map {
                if current_id >= *source_start && current_id < *source_start + *len {
                    current_id = current_id - *source_start + *dest_start;
                    break;
                }
            }
        }

        if current_id < closest {
            closest = current_id;
        }
    }

    println!("Closest: {}", closest);
}
