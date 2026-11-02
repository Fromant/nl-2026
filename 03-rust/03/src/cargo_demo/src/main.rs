// Корень бинарного crate: использует библиотеку своего же package
use cargo_demo::dist;
use cargo_demo::geometry::Point;

fn main() {
    let a = Point { x: 0.0, y: 0.0 };
    let b = Point { x: 3.0, y: 4.0 };
    println!("dist = {}", dist(&a, &b));
}
