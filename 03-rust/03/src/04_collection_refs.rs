// Часть 3, слайд 4: «Ссылки на элементы коллекций»

fn main() {
    let mut names = vec![String::from("Alice"), String::from("Bob")];

    for n in &names {                  // перебор ссылок, вектор цел
        println!("{n}");
    }

    let first = &names[0];             // &String, без переноса владения
    println!("{first}");               // последнее использование first
    names.push(String::from("Carol")); // ок: ссылок больше нет

    // let first = &names[0];
    // names.push(String::from("Dan")); // E0502: буфер может переехать
    // println!("{first}");             // а first ещё нужна

    for n in names {                   // перебор по значению потребляет вектор
        println!("{n}");
    }
}
