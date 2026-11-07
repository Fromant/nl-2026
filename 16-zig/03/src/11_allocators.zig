const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(
        std.heap.page_allocator,
    );
    defer arena.deinit();
    const a = arena.allocator();
    const name = try a.dupe(u8, "Zig");
    const values = try a.alloc(u32, 3);
    @memset(values, 7);
    std.debug.assert(values[2] == 7);
    std.debug.print("arena={s}, values={any}\n", .{ name, values });

    var backing: [64]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&backing);
    const buf = try fixed.allocator().alloc(u8, 16);
    @memset(buf, 1);
    std.debug.assert(buf[0] == 1);
    std.debug.print("fixed={d}\n", .{buf.len});
}
