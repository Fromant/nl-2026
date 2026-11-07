const std = @import("std");

fn square(n: u32) u32 {
    return n * n;
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var first = io.async(square, .{12});
    // Also await first if concurrent fails.
    defer _ = first.await(io);
    var second = try io.concurrent(square, .{5});
    const b = second.await(io);
    const a = first.await(io);
    std.debug.assert(a + b == 169);
    std.debug.print("tasks={d}\n", .{a + b});
}
