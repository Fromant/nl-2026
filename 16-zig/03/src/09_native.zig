const std = @import("std");
const builtin = @import("builtin");

pub fn main() void {
    std.debug.print(
        "target={s}-{s}, mode={s}\n", .{
        @tagName(builtin.cpu.arch),
        @tagName(builtin.os.tag),
        @tagName(builtin.mode),
    });
}
