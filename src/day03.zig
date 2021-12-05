const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day03.txt");
const width = indexOf(u8, data, '\n').?;

const uint = std.meta.Int(.unsigned, width);

const UintList = List(uint);

const UBitSet = std.bit_set.IntegerBitSet(width);

fn get_gamma(nums: UintList, eql: u1) uint {
    var digits: [2][width]u32 = .{ .{0} ** width, .{0} ** width };
    var bs: UBitSet = UBitSet.initEmpty();

    // count
    for (nums.items) |n| {
        bs.mask = @as(UBitSet.MaskInt, n);

        var i: usize = 0;
        while (i < width) : (i += 1) {
            var d: u1 = if (bs.isSet(i)) 1 else 0;
            digits[d][i] += 1;
        }
    }
    var gamma: uint = 0;
    var i: usize = 0;
    while (i < width) : (i += 1) {
        gamma = gamma << 1;
        if (digits[1][i] > digits[0][i]) {
            gamma += 1;
        } else if (digits[1][i] == digits[0][i]) {
            gamma += eql;
        }
    }
    return gamma;
}

fn load_data() !UintList {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    var nums: UintList = UintList.init(&arena.allocator);
    var lines = util.strtok(data, "\n");
    while (lines.next()) |line| {
        var n: uint = try parseInt(uint, line, 2);
        try nums.append(n);
    }
    return nums;
}

pub fn main() !void {
    { // part 1
        var nums: UintList = try load_data();
        var gamma: uint = get_gamma(nums, 0);
        print("gamma: {d}\n", .{gamma});
        print("epsilon: {d}\n", .{~gamma});
        var rate: u128 = @intCast(u128, gamma) * @intCast(u128, ~gamma);
        print("rate: {d}\n", .{rate});
    }

    var oxygen = find_oxygen: { // part 2.1

        var bs: UBitSet = UBitSet.initEmpty();
        var nums: UintList = try load_data();
        var mask: uint = 0;
        var masked: u4 = width;
        //var pos = 1;
        while (nums.items.len > 1) {
            var gamma: uint = get_gamma(nums, 1);
            bs.mask = @as(UBitSet.MaskInt, gamma);
            mask <<= 1;
            masked -= 1;
            if (bs.isSet(masked)) {
                mask += 1;
            }
            removing: for (nums.items) |n, i| {
                if (n >> masked == mask) continue;
                var cur: uint = n;
                while (cur >> masked != mask) {
                    if (i >= nums.items.len) break :removing;
                    _ = nums.swapRemove(i);
                    if (i >= nums.items.len) break :removing;
                    cur = nums.items[i];
                }
            }
            print("masked: {d} mask: {b} items: {d}\n", .{ masked, mask, nums.items.len });
        }
        break :find_oxygen nums.items[0];
    };

    var co2 = find_co2: { // part 2.1

        var bs: UBitSet = UBitSet.initEmpty();
        var nums: UintList = try load_data();
        var mask: uint = 0;
        var masked: u4 = width;
        //var pos = 1;
        while (nums.items.len > 1) {
            var gamma: uint = get_gamma(nums, 0);
            bs.mask = @as(UBitSet.MaskInt, ~gamma);
            mask <<= 1;
            masked -= 1;
            if (bs.isSet(masked)) {
                mask += 1;
            }
            removing: for (nums.items) |n, i| {
                if (n >> masked == mask) continue;
                var cur: uint = n;
                while (cur >> masked != mask) {
                    if (i >= nums.items.len) break :removing;
                    _ = nums.swapRemove(i);
                    if (i >= nums.items.len) break :removing;
                    cur = nums.items[i];
                }
            }
            print("masked: {d} mask: {b} items: {d}\n", .{ masked, mask, nums.items.len });
        }
        break :find_co2 nums.items[0];
    };

    var rating: u128 = @intCast(u128, oxygen) * @intCast(u128, co2);
    print("oxygen: {d} co2: {d} rating: {d}\n", .{ oxygen, co2, rating });
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
