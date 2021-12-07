const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day06.txt");

const int = usize;

pub fn main() !void {
    var buckets = [1]int{0} ** 9;

    var numtext = tokenize(u8, data, ",\n");

    while (numtext.next()) |ntext| {
        var n = try parseInt(usize, ntext, 10);
        buckets[n] += 1;
    }

    //var days: int = 80;
    var days: int = 256;
    while (days > 0) : (days -= 1) {
        std.mem.rotate(int, &buckets, 1);
        buckets[6] += buckets[8];
    }

    var total: int = 0;
    for (buckets) |b| {
        total += b;
    }

    print("80 days: {d}\n", .{total});
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
