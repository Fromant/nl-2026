// Часть 3, слайд 2: «Владение и функции: отдать, вернуть, одолжить»

fn consume(s: String) {            // забирает владение
    println!("consume: {}", s.len());
}                                  // здесь s уничтожается

fn give_back(s: String) -> String {
    s                              // возвращает владение наружу
}

fn borrow(s: &str) -> usize {      // только читает
    s.len()
}

fn main() {
    let s1 = String::from("hello");
    let n = borrow(&s1);           // s1 по-прежнему владелец
    let s2 = give_back(s1);        // s1 → функция → s2
    // println!("{s1}");           // E0382: s1 перемещена
    println!("{n} {s2}");
    consume(s2);                   // s2 больше недоступна
}
