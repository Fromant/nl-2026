// Часть 3, слайд 6: «Управление памятью: общая картина»

use std::rc::Rc;

fn main() {
    let n = 5;                              // стек: размер известен заранее
    let b = Box::new(5);                    // куча: один владелец
    println!("{} {}", n, b);

    let shared = Rc::new(String::from("общая"));
    let other = Rc::clone(&shared);         // ещё один владелец, счётчик +1
    println!("{} {}", other, Rc::strong_count(&shared)); // 2
}                                           // счётчик 0 → строка освобождена
