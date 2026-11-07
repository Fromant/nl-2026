const std = @import("std");

fn makeSquares() [4]u32 {
    var table: [4]u32 = undefined;
    for (&table, 0..) |*v, i| v.* = @intCast(i * i);
    return table;
}

const Config = struct { port: u16, debug: bool };

pub fn main() void {
    const table = comptime makeSquares();
    std.debug.assert(table[3] == 9);
    std.debug.print("table={any}\n", .{table});
    const names = comptime std.meta.fieldNames(Config);
    inline for (names) |name| {
        std.debug.print("field={s}\n", .{name});
    }
}
