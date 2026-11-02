// Часть 2, слайд 9: «Что происходит со String в функции?»

fn takes(s: String) {          // параметр забирает владение
    println!("takes: {s}");
}

fn reads(s: &str) {            // параметр только читает
    println!("reads: {s}");
}

fn main() {
    let s = String::from("hello");
    reads(&s);                 // ок: s остаётся у нас
    takes(s);                  // владение ушло в функцию
    // println!("{s}");        // E0382: borrow of moved value: `s`
}
