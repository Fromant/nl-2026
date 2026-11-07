const std = @import("std");

const Square = struct {
    side: u32,
    fn area(self: Square) u32 {
        return self.side * self.side;
    }
};
const Rectangle = struct {
    w: u32, h: u32,
    fn area(self: Rectangle) u32 {
        return self.w * self.h;
    }
};

fn areaOf(shape: anytype) u32 {
    return shape.area();
}

const Shape = union(enum) {
    square: Square,
    rectangle: Rectangle,

    fn area(self: Shape) u32 {
        return switch (self) {
            .square => |s| s.area(),
            .rectangle => |r| r.area(),
        };
    }
};

pub fn main() void {
    const a = areaOf(Square{ .side = 3 });
    const shapes = [_]Shape{
        .{ .square = .{ .side = 3 } },
        .{ .rectangle = .{ .w = 2, .h = 5 } },
    };
    var total: u32 = 0;
    for (shapes) |s| total += s.area();
    std.debug.assert(a == 9 and total == 19);
    std.debug.print("static={d}, dynamic={d}\n", .{ a, total });
}
