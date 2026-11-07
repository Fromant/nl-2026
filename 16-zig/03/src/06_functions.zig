const std = @import("std");

fn square(x: i32) i32 { return x * x; }

fn map(input: []const i32,
    output: []i32,
    comptime f: fn (i32) i32) void
{
    std.debug.assert(input.len == output.len);
    for (input, output) |x, *y| y.* = f(x);
}

pub fn main() void {
    const input = [_]i32{ 1, 2, 3 };
    var output: [3]i32 = undefined;
    map(&input, &output, square);
    std.debug.assert(std.mem.eql(i32, &output, &.{ 1, 4, 9 }));
    std.debug.print("map={any}\n", .{output});
}
