// Часть 3, слайд 10: «Модули, crates, packages, Cargo»

mod geometry {                         // модуль = пространство имён
    pub struct Point {
        pub x: f64,
        pub y: f64,
    }

    pub fn dist(a: &Point, b: &Point) -> f64 {
        helper(a.x - b.x, a.y - b.y)
    }

    fn helper(dx: f64, dy: f64) -> f64 { // приватная: снаружи не видна
        (dx * dx + dy * dy).sqrt()
    }
}

use geometry::{dist, Point};           // импорт

fn main() {
    let a = Point { x: 0.0, y: 0.0 };
    let b = Point { x: 3.0, y: 4.0 };
    println!("{}", dist(&a, &b));      // 5
    // geometry::helper(1.0, 1.0);     // E0603: function `helper` is private
}
