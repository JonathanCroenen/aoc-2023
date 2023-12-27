const std = @import("std");

pub const Color = enum {
    Red,
    Green,
    Blue,
};

pub const Cube = struct {
    color: Color,
    num: u32,
};

pub const Hand = struct {
    _cubes: std.ArrayList(Cube),

    const Self = @This();

    pub fn cubes(self: Self) ![]Cube {
        return self._cubes.items;
    }

    pub fn deinit(self: Self) void {
        self._cubes.deinit();
    }
};

pub const Game = struct {
    _hands: std.ArrayList(Hand),

    const Self = @This();

    pub fn hands(self: Self) ![]Hand {
        return self._hands.items;
    }

    pub fn deinit(self: Self) void {
        for (self._hands.items) |hand| {
            hand.deinit();
        }

        self._hands.deinit();
    }
};

pub const Games = struct {
    _games: std.ArrayList(Game),

    const Self = @This();

    pub fn games(self: Self) ![]Game {
        return self._games.items;
    }

    pub fn deinit(self: Self) void {
        for (self._games.items) |game| {
            game.deinit();
        }

        self._games.deinit();
    }
};

pub fn readInput(path: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(path, .{ .mode = std.fs.File.OpenMode.read_only });
    defer file.close();

    const content = try file.readToEndAlloc(std.heap.page_allocator, 100000);
    return content;
}

pub fn parseInput(content: []const u8) !Games {
    var line_iter = std.mem.splitScalar(u8, content, '\n');
    var games = std.ArrayList(Game).init(std.heap.page_allocator);

    while (line_iter.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var game_iter = std.mem.splitAny(u8, line, ":;");
        _ = game_iter.next();
        var parsed_game = std.ArrayList(Hand).init(std.heap.page_allocator);

        while (game_iter.next()) |hand| {
            var cube_iter = std.mem.splitScalar(u8, hand, ',');
            var parsed_hand = std.ArrayList(Cube).init(std.heap.page_allocator);

            while (cube_iter.next()) |cube| {
                var color_iter = std.mem.splitScalar(u8, cube[1..], ' ');
                const n = color_iter.next() orelse unreachable;
                const num = try std.fmt.parseUnsigned(u32, n, 10);
                const color = color_iter.next() orelse unreachable;

                if (std.mem.eql(u8, color, "red")) {
                    try parsed_hand.append(Cube{ .color = Color.Red, .num = num });
                } else if (std.mem.eql(u8, color, "green")) {
                    try parsed_hand.append(Cube{ .color = Color.Green, .num = num });
                } else if (std.mem.eql(u8, color, "blue")) {
                    try parsed_hand.append(Cube{ .color = Color.Blue, .num = num });
                } else {
                    std.debug.print("Invalid color: {s}\n", .{color});
                    std.process.exit(1);
                }
            }

            try parsed_game.append(Hand{ ._cubes = parsed_hand });
        }

        try games.append(Game{ ._hands = parsed_game });
    }

    return Games{ ._games = games };
}
