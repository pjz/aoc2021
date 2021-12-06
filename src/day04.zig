const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day04.txt");

const int = u8;

const BingoCard = struct {
    const Self = @This();
    vals: [5][5]int,
    checked: [5][5]bool,
    score: ?u64 = null,

    pub fn init(lines: [5]Str) !Self {
        var card: Self = .{
            .vals = [1][5]int{[1]int{0} ** 5} ** 5,
            .checked = [1][5]bool{[1]bool{false} ** 5} ** 5,
        };
        for (lines) |line, i| {
            var nums = util.strtok(line, " ");
            var j: usize = 0;
            while (j < 5) : (j += 1) {
                var n: int = try parseInt(int, nums.next().?, 10);
                card.vals[i][j] = n;
                //print("added {d}\n", .{n});
            }
        }
        return card;
    }

    pub fn mark(self: *Self, n: int) void {
        // find occurances of n on the board and check the off
        var i: u3 = 0;
        while (i < self.vals.len) : (i += 1) {
            var j: u3 = 0;
            while (j < self.vals.len) : (j += 1) {
                if (self.vals[i][j] == n)
                    self.checked[i][j] = true;
            }
        }
        // check for bingo
        if (self.bingo()) {
            self.score = self.calc_score(n);
            print("bingo! placing {d} score {d}\n", .{ n, self.score });
        }
    }

    pub fn bingo(self: Self) bool {
        var i: u3 = 0;
        var all: bool = true;
        // horizontal
        while (i < self.vals.len) : (i += 1) {
            var j: u3 = 0;
            all = true;
            while (j < self.vals.len) : (j += 1) {
                if (!self.checked[i][j]) {
                    all = false;
                    break;
                }
            }
            if (all) return true;
        }
        // vertical
        i = 0;
        while (i < self.vals.len) : (i += 1) {
            all = true;
            var j: u3 = 0;
            while (j < self.vals.len) : (j += 1) {
                if (!self.checked[j][i]) {
                    all = false;
                    break;
                }
            }
            if (all) return true;
        }
        // down & right
        i = 0;
        all = true;
        while (i < self.vals.len) : (i += 1) {
            if (!self.checked[i][i]) {
                all = false;
                break;
            }
        }
        if (all) return true;
        // up & right
        i = 0;
        all = true;
        while (i < self.vals.len) : (i += 1) {
            if (!self.checked[i][self.vals.len - 1 - i]) {
                all = false;
                break;
            }
        }
        if (all) return true;
        return false;
    }

    fn calc_score(self: Self, final_num: int) u64 {
        var s: u64 = 0;

        // sum of all unmarked numbers
        var i: u3 = 0;
        var unchecked: usize = 0;
        while (i < 5) : (i += 1) {
            var j: u3 = 0;
            while (j < 5) : (j += 1) {
                if (!self.checked[i][j]) {
                    s += self.vals[i][j];
                    unchecked += 1;
                }
            }
        }
        print("scoring {d} unchecked total of {d} score {d}\n", .{ unchecked, s, s * final_num });
        return s * final_num;
    }

    fn show(self: Self) void {
        var i: u3 = 0;
        while (i < 5) : (i += 1) {
            var j: u3 = 0;
            while (j < 5) : (j += 1) {
                var sigil: u8 = if (self.checked[i][j]) '<' else ' ';
                print("{d:2}{c}", .{ self.vals[i][j], sigil });
            }
            print("\n", .{});
        }
        print("\n", .{});
    }
};

const BingoCardList = List(BingoCard);

pub fn main() !void {
    var cards = BingoCardList.init(gpa);

    var lines = split(u8, data, "\n");
    // load numbers, save for later
    var nums_text = lines.next().?;
    // load cards
    while (lines.next()) |line| {
        if (line.len <= 2) {
            continue;
        }
        var new_card = try BingoCard.init(.{
            line,
            lines.next().?,
            lines.next().?,
            lines.next().?,
            lines.next().?,
        });
        try cards.append(new_card);
        new_card.show();
    }
    //    if (true) return;
    // okay, now iter over numbers
    var num_iter = split(u8, nums_text, ",");
    var found_bingo = false;
    while (num_iter.next()) |num_text| {
        var n = try parseInt(int, num_text, 10);
        print("Placing {d}\n", .{n});
        for (cards.items) |*card| {
            card.mark(n);
            card.show();
            if (card.score) |score| {
                found_bingo = true;
                print("Found bingo with score: {d}\n", .{score});
                return;
            }
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
