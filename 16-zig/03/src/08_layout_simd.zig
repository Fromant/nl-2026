const std = @import("std");

const Flags = packed struct(u8) {
    ready: bool,
    mode: u3,
    reserved: u4 = 0,
};

pub fn main() void {
    const flags = Flags{ .ready = true, .mode = 3 };
    const raw: u8 = @bitCast(flags);
    std.debug.assert(raw == 7);
    const a: @Vector(4, i32) = .{ 1, 2, 3, 4 };
    const b: @Vector(4, i32) = @splat(10);
    const result = a + b;
    std.debug.assert(@reduce(.Add, result) == 50);
    std.debug.print("flags={d}, vector={any}\n", .{ raw, result });
}
