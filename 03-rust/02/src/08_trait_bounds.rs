// Часть 2, слайд 8: «Trait bounds: ограничиваем T»

use std::fmt::Display;

// Без ограничения не компилируется:
// fn print_bad<T>(v: T) { println!("{v}"); }
// E0277: `T` doesn't implement `std::fmt::Display`

fn show<T: Display>(v: T) {
    println!("[{v}]");
}

fn show_max<T>(a: T, b: T)
where
    T: Display + PartialOrd,           // несколько ограничений
{
    if a > b { show(a) } else { show(b) }
}

fn main() {
    show(42);
    show("hello");
    show_max(3, 8);                    // [8]
}
