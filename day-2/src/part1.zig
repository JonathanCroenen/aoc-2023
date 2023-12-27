const std = @import("std");
const common = @import("common.zig");

const Games = common.Games;
const Game = common.Game;
const Hand = common.Hand;
const Cube = common.Cube;
const Color = common.Color;

const MAX_RED = 12;
const MAX_GREEN = 13;
const MAX_BLUE = 14;

fn isNumCubesPossible(cube: Cube) bool {
    const color = cube.color;
    const num = cube.num;

    switch (color) {
        Color.Red => return num <= MAX_RED,
        Color.Green => return num <= MAX_GREEN,
        Color.Blue => return num <= MAX_BLUE,
    }
}

fn isHandPossible(hand: *const Hand) !bool {
    for (try hand.cubes()) |cube| {
        if (!isNumCubesPossible(cube)) {
            return false;
        }
    }

    return true;
}

fn isGamePossible(game: *const Game) !bool {
    for (try game.hands()) |hand| {
        if (!try isHandPossible(&hand)) {
            return false;
        }
    }

    return true;
}

pub fn processInput(content: *const Games) !void {
    var total: usize = 0;

    for (try content.games(), 1..) |game, index| {
        const possible = try isGamePossible(&game);

        total += if (possible) index else 0;
    }

    std.debug.print("Part1 total: {}\n", .{total});
}
