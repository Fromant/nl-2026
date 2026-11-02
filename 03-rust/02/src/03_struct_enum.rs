// Часть 2, слайд 3: «Свои типы: struct и enum»

use std::f64::consts::PI;

struct Point {
    x: i32,
    y: i32,
}

enum Shape {
    Circle(f64),               // вариант с данными
    Rect { w: f64, h: f64 },   // вариант с именованными полями
}

fn area(s: Shape) -> f64 {
    match s {
        Shape::Circle(r) => PI * r * r,
        Shape::Rect { w, h } => w * h,
    }
}

fn main() {
    let p = Point { x: 3, y: 4 };
    println!("({}, {})", p.x, p.y);

    println!("{:.2}", area(Shape::Circle(1.0)));          // 3.14
    println!("{}", area(Shape::Rect { w: 2.0, h: 5.0 })); // 10
}
