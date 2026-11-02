// Часть 3, слайд 7: «Option, Result, match, if let»

fn main() {
    let names = ["Анна", "Олег"];
    let pos = names.iter().position(|n| *n == "Олег");
    match pos {                         // Option<usize>
        Some(i) => println!("индекс {i}"),
        None => println!("не найден"),
    }

    let age = "21".parse::<u8>();       // Result<u8, ParseIntError>
    if let Ok(a) = age {
        println!("возраст {a}");
    }

    match "abc".parse::<u8>() {
        Ok(a) => println!("возраст {a}"),
        Err(e) => println!("ошибка: {e}"), // invalid digit found in string
    }
}
