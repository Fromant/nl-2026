// Часть 2, слайд 10: «Ownership: у каждого значения один владелец»

fn make() -> String {
    String::from("new")        // владение уходит вызывающему коду
}

fn main() {
    {
        let s = String::from("hello"); // s — владелец
        println!("{s}");
    }                                  // конец блока: drop(s), буфер освобождён
    // println!("{s}");                // E0425: s здесь не существует

    let t = make();                    // владелец — t
    println!("{t}");
}
