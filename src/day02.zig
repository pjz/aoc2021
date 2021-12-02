const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day02.txt");

const Direction = enum { forward, up, down };

pub fn main() !void {
    { // part 1
        var lines = util.strtok(data, "\n");
        var x: u128 = 0;
        var y: u128 = 0;
        while (lines.next()) |line| {
            var splitter = split(u8, line, " ");
            var direction = std.meta.stringToEnum(Direction, splitter.next().?).?;
            var distance = try std.fmt.parseInt(u128, splitter.next().?, 10);
            switch (direction) {
                .forward => {
                    x += distance;
                },
                .up => {
                    y -= distance;
                },
                .down => {
                    y += distance;
                },
            }
        }
        print("{d}, {d} -> {d}\n", .{ x, y, x * y });
    }
    { // part 2
        var lines = util.strtok(data, "\n");
        var x: i128 = 0;
        var y: i128 = 0;
        var aim: i128 = 0;
        while (lines.next()) |line| {
            var splitter = split(u8, line, " ");
            var direction = std.meta.stringToEnum(Direction, splitter.next().?).?;
            var distance = try std.fmt.parseInt(i128, splitter.next().?, 10);
            switch (direction) {
                .forward => {
                    x += distance;
                    y += (aim * distance);
                },
                .up => {
                    aim -= distance;
                },
                .down => {
                    aim += distance;
                },
            }
        }
        print("{d}, {d} -> {d}\n", .{ x, y, x * y });
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
