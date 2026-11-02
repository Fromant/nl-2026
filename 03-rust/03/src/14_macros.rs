// Часть 3, слайд 14: «Макросы»

macro_rules! square {
    ($x:expr) => { $x * $x };
}

macro_rules! my_vec {
    ($($x:expr),*) => {{
        let mut v = Vec::new();
        $( v.push($x); )*              // повтор для каждого аргумента
        v
    }};
}

#[derive(Debug, Clone, PartialEq)]     // процедурный макрос derive
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    println!("{}", square!(4));        // 16
    println!("{}", square!(1 + 1));    // 4, а не 3: $x — целое выражение
    println!("{:?}", my_vec![1, 2, 3]); // [1, 2, 3]

    let p = Point { x: 1, y: 2 };
    println!("{:?} {}", p.clone(), p == Point { x: 1, y: 2 });
    // println!("{} {}", 1);           // ошибка компиляции: 2 места, 1 аргумент
}
