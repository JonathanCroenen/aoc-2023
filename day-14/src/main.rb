require "set"

module Tile
    EMPTY = "."
    SQUARE_ROCK = "#"
    ROUND_ROCK = "O"
end

module Tilt
    NORTH = 0
    EAST = 1
    SOUTH = 2
    WEST = 3
end

def parse_input(path)
    file = File.open(path, "r")
    lines = file.readlines.map(&:chomp)
    file.close

    return lines.map(&:chars)
end

def is_movable?(grid, x, y)
    return (x >= 0 and x < grid[0].length() and y >= 0 and y < grid.length() and grid[y][x] == Tile::EMPTY)
end

def tilt_platform!(grid, tilt)
    range_i, range_j = nil, nil
    offset_x, offset_y = 0, 0

    case tilt
    when Tilt::NORTH
        range_i = 0..grid[0].length() - 1
        range_j = 0..grid.length() - 1
        offset_y = -1
    when Tilt::EAST
        range_i = 0..grid.length() - 1
        range_j = (grid[0].length() - 1).downto(0)
        offset_x = 1
    when Tilt::SOUTH
        range_i = 0..grid[0].length() - 1
        range_j = (grid.length() - 1).downto(0)
        offset_y = 1
    when Tilt::WEST
        range_i = 0..grid.length() - 1
        range_j = 0..grid[0].length() - 1
        offset_x = -1
    end

    moved = true
    while moved
        moved = false
        for i in range_i
            for j in range_j
                x, y = i, j
                if tilt == Tilt::EAST or tilt == Tilt::WEST
                    x, y = j, i
                end

                if grid[y][x] == Tile::ROUND_ROCK and is_movable?(grid, x + offset_x, y + offset_y)
                    grid[y][x] = Tile::EMPTY
                    grid[y + offset_y][x + offset_x] = Tile::ROUND_ROCK
                    moved = true
                end
            end
        end
    end
end

def cycle_tilt!(grid)
    tilt_platform!(grid, Tilt::NORTH)
    tilt_platform!(grid, Tilt::WEST)
    tilt_platform!(grid, Tilt::SOUTH)
    tilt_platform!(grid, Tilt::EAST)
end

def calc_load(grid)
    load = 0
    grid.each_with_index do |line, y|
        for char in line
            if char == Tile::ROUND_ROCK
            load += grid.length() - y
            end
        end
    end

    return load
end

def print_grid(grid)
    for line in grid
        puts line.join("")
    end

    puts ""
end

def part1(grid, print=false)
    if print
        print_grid(grid)
    end
    tilt_platform!(grid, Tilt::NORTH)
    if print
        print_grid(grid)
    end

    load = calc_load(grid)
    puts "Part1 load: #{load}"
end

NUM_ITERATIONS = 1000000000

def part2(grid, print=false)
    if print
        print_grid(grid)
    end

    seen = Set.new
    order = []
    for i in 0...NUM_ITERATIONS
        grid_clone = grid.map(&:clone)
        order.append(grid_clone)
        seen.add(grid_clone)
        cycle_tilt!(grid)

        if seen.include?(grid)
            j = order.index(grid)
            final_index = (NUM_ITERATIONS - j) % (i + 1 - j) + j
            grid = order[final_index]
            break
        end
    end

    if print
        print_grid(grid)
    end

    load = calc_load(grid)
    puts "Part2 load: #{load}"
end

def main
    grid = parse_input("input/input.txt")
    part1(grid.map(&:clone))
    part2(grid.map(&:clone))
end


main
