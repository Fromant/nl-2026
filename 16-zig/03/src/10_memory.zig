const std = @import("std");

fn makeData(a: std.mem.Allocator) ![]u8 {
    const data = try a.alloc(u8, 4);
    @memset(data, 42);
    return data; // Caller owns the allocation.
}

pub fn main() !void {
    var debug_allocator:
        std.heap.DebugAllocator(.{}) = .init;
    defer std.debug.assert(
        debug_allocator.deinit() == .ok,
    );
    const a = debug_allocator.allocator();
    const data = try makeData(a);
    defer a.free(data);
    std.debug.assert(data.len == 4 and data[0] == 42);
    std.debug.print("data={any}\n", .{data});
}

test "allocated data has expected content and is freed" {
    const a = std.testing.allocator;
    const data = try makeData(a);
    defer a.free(data);
    try std.testing.expectEqualSlices(u8, &.{ 42, 42, 42, 42 }, data);
}

test "allocation failure propagates" {
    try std.testing.expectError(error.OutOfMemory,
        makeData(std.testing.failing_allocator));
}
