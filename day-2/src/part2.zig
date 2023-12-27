const std = @import("std");
const common = @import("common.zig");

const Games = common.Games;
const Game = common.Game;
const Hand = common.Hand;
const Cube = common.Cube;
const Color = common.Color;

const MinCubes = struct {
    red: u32,
    green: u32,
    blue: u32,
};

fn getMinCubes(game: *const Game) !MinCubes {
    var min_cubes = MinCubes{
        .red = 0,
        .green = 0,
        .blue = 0,
    };

    for (try game.hands()) |hand| {
        for (try hand.cubes()) |cube| {
            switch (cube.color) {
                Color.Red => if (min_cubes.red < cube.num) {
                    min_cubes.red = cube.num;
                },
                Color.Green => if (min_cubes.green < cube.num) {
                    min_cubes.green = cube.num;
                },
                Color.Blue => if (min_cubes.blue < cube.num) {
                    min_cubes.blue = cube.num;
                },
            }
        }
    }

    return min_cubes;
}

pub fn processInput(content: *const Games) !void {
    var total: u64 = 0;

    for (try content.games()) |game| {
        const min_cubes = try getMinCubes(&game);
        total += min_cubes.red * min_cubes.green * min_cubes.blue;
    }

    std.debug.print("Part2 total: {}\n", .{total});
}
