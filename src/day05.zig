const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day05.txt");

const Point = struct {
    x: u32,
    y: u32,
    pub fn init(x: u32, y: u32) Point {
        return Point{ .x = x, .y = y };
    }
    pub fn from_str(s: []const u8) !Point {
        var iter = tokenize(u8, s, " ,");
        return Point.init(
            try parseInt(u32, iter.next().?, 10),
            try parseInt(u32, iter.next().?, 10),
        );
    }
};

const Line = struct {
    const Self = @This();
    a: Point,
    b: Point,
    pub fn init(a: Point, b: Point) Line {
        return Line{ .a = a, .b = b };
    }

    pub const Iterator = struct {
        line: *const Self,
        cur: ?Point = null,
        started: bool = false,
        pub fn next(it: *Iterator) ?Point {
            var dest = it.line.b;
            if (it.cur) |cur| {
                var newx: u32 = cur.x;
                var newy: u32 = cur.y;
                if (cur.x != dest.x)
                    newx = if (cur.x < dest.x) newx + 1 else newx - 1;
                if (cur.y != dest.y)
                    newy = if (cur.y < dest.y) newy + 1 else newy - 1;
                if ((newx != cur.x) or (newy != cur.y)) {
                    it.cur = Point.init(newx, newy);
                } else {
                    it.cur = null;
                }
            } else if (!it.started) {
                it.cur = it.line.a;
            }
            return it.cur;
        }
    };

    pub fn iterator(self: Self) Iterator {
        return .{ .line = &self };
    }

    pub fn part_1_iterator(self: Self) Iterator {
        // ignore the line if it's not horizontal or vertical
        if ((self.a.x != self.b.x) and (self.a.y != self.b.y))
            return .{ .line = &Line.init(self.a, self.a), .started = true };
        return .{ .line = &self };
    }

    pub fn from_str(s: []const u8) !Line {
        var coord_splitter = split(u8, s, " -> ");
        return Line.init(
            try Point.from_str(coord_splitter.next().?),
            try Point.from_str(coord_splitter.next().?),
        );
    }
};

const Height = u2;
const FloorMap = Map(Point, Height);

fn floor_raise(map: *FloorMap, pt: Point) !void {
    var height = map.get(pt) orelse 0;
    height += 1;
    if (height > 2) return;
    try map.put(pt, height);
}

pub fn main() !void {
    print("starting\n", .{});
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    var allocator = &arena.allocator;

    var floor: FloorMap = FloorMap.init(allocator);

    print("reading\n", .{});
    var lines = util.strtok(data, "\n");
    while (lines.next()) |line_text| {
        var line = try Line.from_str(line_text);
        var iter = line.iterator();
        while (iter.next()) |pt| {
            try floor_raise(&floor, pt);
        }
    }
    print("counting\n", .{});
    var total: u64 = 0;
    var floor_counter = floor.valueIterator();
    while (floor_counter.next()) |val| {
        if (val.* >= 2) {
            total += 1;
        }
    }
    print("part 1: {d}\n", .{total});
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
