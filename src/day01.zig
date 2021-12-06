const std = @import("std");
const util = @import("util.zig");

const data = @embedFile("../data/day01.txt");
const parseInt = std.fmt.parseInt;
const print = std.debug.print;

pub fn main() !void {
    { // part 1
        var lines = util.strtok(data, "\n");
        var increases: u128 = 0;
        var prev_def: ?u128 = null;
        while (lines.next()) |line| {
            var cur = try parseInt(u128, line, 10);
            if (prev_def) |prev| {
                if (cur > prev) {
                    increases += 1;
                }
            }
            prev_def = cur;
        }
        print("{d}\n", .{increases});
    }
    { // part 2
        var lines = util.strtok(data, "\n");
        var window: [3]u128 = .{ 0, 0, 0 };
        var i: usize = 0;
        var increases: u128 = 0;
        while (lines.next()) |line| {
            i += 1;
            var cur = try parseInt(u128, line, 10);
            var window_i = i % 3;
            if (i > 3) {
                if (cur > window[window_i])
                    increases += 1;
            }
            window[window_i] = cur;
        }
        print("{d}\n", .{increases});
    }
}
