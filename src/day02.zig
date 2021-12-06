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

const uint = uint;
const split = std.mem.split;
const print = std.debug.print;
const parseInt = std.fmt.parseInt;

pub fn main() !void {
    { // part 1
        var lines = util.strtok(data, "\n");
        var x: uint = 0;
        var y: uint = 0;
        while (lines.next()) |line| {
            var splitter = split(u8, line, " ");
            var direction = std.meta.stringToEnum(Direction, splitter.next().?).?;
            var distance = try parseInt(uint, splitter.next().?, 10);
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
            var distance = try parseInt(i128, splitter.next().?, 10);
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
