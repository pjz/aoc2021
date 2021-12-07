const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day07.txt");

const CrabList = Map(usize, usize);

fn fuelAt(crabs: CrabList, pos: usize) usize {
    var fuel: usize = 0;
    var iter = crabs.iterator();
    while (iter.next()) |kv| {
        const c_pos = kv.key_ptr.*;
        const c_count = kv.value_ptr.*;
        var distance = if (pos > c_pos) (pos - c_pos) else (c_pos - pos);
        fuel += c_count * distance * (distance + 1) / 2;
    }
    return fuel;
}

fn fuelAt_pt1(crabs: CrabList, pos: usize) usize {
    var fuel: usize = 0;
    var iter = crabs.iterator();
    while (iter.next()) |kv| {
        const c_pos = kv.key_ptr.*;
        const c_count = kv.value_ptr.*;
        fuel += c_count * (if (pos > c_pos) (pos - c_pos) else (c_pos - pos));
    }
    return fuel;
}

pub fn main() !void {
    var crabs = CrabList.init(gpa);
    var numtext = tokenize(u8, data, ",\n");

    var max_pos: usize = 0;
    while (numtext.next()) |pos_str| {
        var pos = try parseInt(usize, pos_str, 10);
        var cur = crabs.get(pos) orelse 0;
        cur += 1;
        try crabs.put(pos, cur);
        if (pos > max_pos) max_pos = pos;
    }

    var min_fuel: usize = fuelAt(crabs, 0);
    while (max_pos >= 1) : (max_pos -= 1) {
        var fuel = fuelAt(crabs, max_pos);
        if (fuel < min_fuel) {
            print("{d} takes {d}\n", .{ max_pos, fuelAt(crabs, max_pos) });
            min_fuel = fuel;
        }
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
