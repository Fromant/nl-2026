// Часть 2, слайд 11: «Move: владение переходит»

fn main() {
    let s1 = String::from("hello");
    let s2 = s1;               // move: владелец теперь s2
    println!("{s2}");          // ок
    // println!("{s1}");       // E0382: borrow of moved value: `s1`
}
