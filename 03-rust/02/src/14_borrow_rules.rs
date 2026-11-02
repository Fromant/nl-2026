// Часть 2, слайд 14: «Правила borrowing»

fn main() {
    // 1. Много &T одновременно — можно
    let s = String::from("data");
    let r1 = &s;
    let r2 = &s;
    println!("{r1} {r2}");

    // 2. &mut, пока нужна другая ссылка, — нельзя:
    // let mut s = String::from("data");
    // let r = &s;
    // let m = &mut s;          // E0502: cannot borrow `s` as mutable
    // m.push('!');
    // println!("{r}");         // r ещё используется

    // 3. Заимствование кончается на последнем использовании ссылки
    let mut s = String::from("data");
    let r = &s;
    println!("{r}");           // последнее использование r
    let m = &mut s;            // теперь можно
    m.push('!');
    println!("{s}");           // data!
}
