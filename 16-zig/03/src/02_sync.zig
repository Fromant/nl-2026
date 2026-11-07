const std = @import("std");

const Counter = struct {
    mutex: std.Io.Mutex = .init,
    value: u32 = 0,

    fn increment(self: *Counter, io: std.Io) void {
        self.mutex.lockUncancelable(io);
        defer self.mutex.unlock(io);
        self.value += 1;
    }
};

fn worker(counter: *Counter, io: std.Io) void {
    for (0..10_000) |_| counter.increment(io);
}

pub fn main(init: std.process.Init) !void {
    var counter: Counter = .{};
    {
        const t = try std.Thread.spawn(.{}, worker, .{ &counter, init.io });
        defer t.join();
        worker(&counter, init.io);
    }
    std.debug.assert(counter.value == 20_000);
    var atomic = std.atomic.Value(u32).init(0);
    _ = atomic.fetchAdd(1, .monotonic);
    std.debug.assert(atomic.load(.monotonic) == 1);
    std.debug.print("counter={d}, atomic={d}\n", .{ counter.value, atomic.load(.monotonic) });
}
