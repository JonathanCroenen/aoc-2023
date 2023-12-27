const std = @import("std");

const common = @import("common.zig");
const part1 = @import("part1.zig");
const part2 = @import("part2.zig");

pub fn main() !void {
    const input = try common.readInput("input/part1.txt");
    var games = try common.parseInput(input);

    try part1.processInput(&games);
    try part2.processInput(&games);

    games.deinit();
}
