// Часть 2, слайд 7: «Generics: декларация, инстанцирование, использование»

// декларация
fn largest<T: PartialOrd>(list: &[T]) -> &T {
    let mut max = &list[0];            // срез не должен быть пустым
    for item in list {
        if item > max {
            max = item;
        }
    }
    max
}

struct Point<T> {
    x: T,
    y: T,
}

fn main() {
    // инстанцирование и использование
    let a = largest(&[1, 7, 3]);             // T = i32 (выведен)
    let b = largest::<f64>(&[0.5, 2.5]);     // T = f64 (явно)
    let p = Point { x: 1.0, y: 2.0 };        // Point<f64>
    println!("{a} {b} ({}, {})", p.x, p.y);
}
