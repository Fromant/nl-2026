// Часть 3, слайд 5: «Lifetimes»

fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}

fn first_word(s: &str) -> &str {       // здесь lifetime выводится сам
    s.split(' ').next().unwrap_or("")
}

fn main() {
    let a = String::from("borrow");
    let b = String::from("own");
    let r = longest(&a, &b);
    println!("{r}");                   // borrow
    println!("{}", first_word("hello world")); // hello

    // let r;
    // let a = String::from("long string");
    // {
    //     let b = String::from("xyz");
    //     r = longest(&a, &b);
    // }                               // b уничтожена
    // println!("{r}");                // E0597: `b` does not live long enough
}
