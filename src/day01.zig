const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day01.txt");

pub fn main() !void {
    { // part 1
        var lines = util.strtok(data, "\n");
        var increases: u128 = 0;
        var prev_def: ?u128 = null;
        while (lines.next()) |line| {
            var cur = try std.fmt.parseInt(u128, line, 10);
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
            var cur = try std.fmt.parseInt(u128, line, 10);
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

// Useful stdlib functions
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const min = std.math.min;
const min3 = std.math.min3;
const max = std.math.max;
const max3 = std.math.max3;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.sort;
const asc = std.sort.asc;
const desc = std.sort.desc;
