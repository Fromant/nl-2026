const std = @import("std");

fn sum(data: []const u32, out: *u32) void {
    out.* = 0;
    for (data) |n| out.* += n;
}

pub fn main() !void {
    const data = [_]u32{ 1, 2, 3, 4, 5, 6 };
    var left: u32 = 0;
    var right: u32 = 0;
    {
        const t = try std.Thread.spawn(
            .{}, sum, .{ data[0..3], &left },
        );
        defer t.join();
        sum(data[3..], &right);
    }
    std.debug.assert(left + right == 21);
    std.debug.print("sum={d}\n", .{left + right});
}
