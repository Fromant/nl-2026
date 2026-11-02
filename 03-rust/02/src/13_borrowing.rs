// Часть 2, слайд 13: «Borrowing: &T и &mut T»

fn len_of(s: &str) -> usize {  // &T: читаем
    s.len()
}

fn append(s: &mut String) {    // &mut T: меняем
    s.push_str("!");
}

fn main() {
    let mut t = String::from("hi");
    let n = len_of(&t);        // владелец по-прежнему t
    append(&mut t);            // переменная обязана быть mut
    println!("{t} {n}");       // hi! 2
}
