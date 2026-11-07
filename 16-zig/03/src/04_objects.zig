const std = @import("std");

const Position = struct { x: i32 = 0, y: i32 = 0 };
const Player = struct {
    position: Position = .{},
    score: u32 = 0,

    fn move(self: *Player, dx: i32) void {
        self.position.x += dx;
    }
};

pub fn main() void {
    var player: Player = .{};
    player.move(3);
    std.debug.assert(player.position.x == 3);
    std.debug.print("x={d}\n", .{player.position.x});
}
