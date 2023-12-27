use std::time::Instant;

struct Range {
    start: i64,
    end: i64,
    len: i64,
}

impl Range {
    fn new(start: i64, len: i64) -> Range {
        Range {
            start,
            end: start + len,
            len,
        }
    }

    fn overlap(&self, other: &Range) -> Option<Range> {
        let start = std::cmp::max(self.start, other.start);
        let end = std::cmp::min(self.end, other.end);

        if start < end {
            Some(Range::new(start, end - start))
        } else {
            None
        }
    }
}

struct Mapping {
    source: Range,
    shift: i64,
}

impl Mapping {
    fn new(source: Range, destination: Range) -> Mapping {
        assert!(source.len == destination.len);

        let shift = destination.start as i64 - source.start as i64;

        Mapping {
            source,
            shift
        }
    }
}

struct Map {
    mappings: Vec<Mapping>,
}

impl Map {
    fn new(mappings: Vec<Mapping>) -> Map {
        let mut m = mappings;
        m.sort_by(|a, b| a.source.start.cmp(&b.source.start));
        Map { mappings: m }
    }

    fn map(&self, range: Range) -> Vec<Range> {
        let mut overlaps = Vec::new();
        let mut result = Vec::new();

        // Map to the destination range for the overlapping parts
        for mapping in &self.mappings {
            if let Some(overlap) = mapping.source.overlap(&range) {
                result.push(Range::new(
                    (overlap.start as i64 + mapping.shift) as i64,
                    overlap.len,
                ));

                // Keep track of the overlaps to fill in the gaps later
                overlaps.push(overlap);
            }
        }

        // If there are no overlaps, return the original range
        if overlaps.len() == 0 {
            return vec![range];
        }

        // Add the part ofter the last overlap that sticks out
        if range.start < overlaps[0].start {
            result.push(Range::new(
                range.start,
                std::cmp::min(overlaps[0].start, range.end) - range.start,
            ));
        }

        // Add the part before the first overlap that sticks out
        if range.end > overlaps[overlaps.len() - 1].end {
            let s = std::cmp::max(overlaps[overlaps.len() - 1].end, range.start);
            result.push(Range::new(s, range.end - s));
        }

        // Add the parts between the overlaps
        for (o1, o2) in overlaps.iter().zip(overlaps.iter().skip(1)) {
            let s = std::cmp::max(o1.end, range.start);
            let e = std::cmp::min(o2.start, range.end);

            if s < e {
                result.push(Range::new(s, e - s));
            }
        }

        result
    }
}

// Some disgusting parsing written in about 10 min, it wouldn't be aoc without it lol
fn parse_input(path: &str) -> (Vec<Range>, Vec<Map>) {
    let parse_num = |s: &str| -> i64 { s.parse::<i64>().unwrap() };

    let input = std::fs::read_to_string(path).unwrap();
    let seed_line_end = input.find('\n').unwrap();

    let mut seeds = Vec::new();
    let mut iter = input[7..seed_line_end].split(' ');
    loop {
        let (start, len) = match (iter.next(), iter.next()) {
            (_, None) => break,
            (None, _) => break,
            (Some(start), Some(len)) => (parse_num(start), parse_num(len)),
        };

        seeds.push(Range::new(start, len));
    }

    let maps = input[seed_line_end + 2..]
        .split("\n\n")
        .map(|group| {
            let iter = group.split("\n").skip(1);

            let mut map = Vec::new();
            for line in iter {
                if line.len() == 0 {
                    continue;
                }

                let mut iter = line.split(" ");
                let dest_start = parse_num(iter.next().unwrap());
                let source_start = parse_num(iter.next().unwrap());
                let len = parse_num(iter.next().unwrap());

                map.push(Mapping::new(
                    Range::new(source_start, len),
                    Range::new(dest_start, len),
                ));
            }
            Map::new(map)
        })
        .collect::<Vec<Map>>();

    (seeds, maps)
}

fn solve(seeds: Vec<Range>, maps: Vec<Map>) {
    let mut closest = i64::MAX;

    for range in seeds {
        let mut ranges = vec![range];

        // Run the seed range through the maps
        for map in &maps {
            let mut new_ranges = Vec::new();
            for range in ranges {
                let mut mapped = map.map(range);
                new_ranges.append(&mut mapped);
            }
            ranges = new_ranges;
        }

        // See if we have a lower bound that is closer than we have found before
        for range in ranges {
            if range.start < closest {
                closest = range.start;
            }
        }
    }

    println!("Closest: {}", closest);
}

fn main() {
    let timer = Instant::now();
    let (seeds, maps) = parse_input("input/input.txt");
    let parse_time = timer.elapsed();
    println!("Parse Time: {:?}", parse_time);

    let timer = Instant::now();
    solve(seeds, maps);
    let solve_time = timer.elapsed();
    println!("Solve Time: {:?}", solve_time);

    println!("Total Time: {:?}", parse_time + solve_time);
}
