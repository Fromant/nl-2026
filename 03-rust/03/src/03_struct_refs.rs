// Часть 3, слайд 3: «Ссылки в структурах»

struct User {
    name: String,                  // структура владеет строкой
}

struct UserRef<'a> {
    name: &'a str,                 // структура ссылается на чужую строку
}

fn main() {
    let name = String::from("Alice");
    let u = User { name };         // name перемещена в u
    println!("{}", u.name);

    let name = String::from("Bob");
    let r = UserRef { name: &name };
    println!("{} {}", name, r.name); // доступны оба

    // Ссылка не может пережить данные:
    // let r;
    // {
    //     let tmp = String::from("Tmp");
    //     r = UserRef { name: &tmp };
    // }                           // tmp уничтожена
    // println!("{}", r.name);     // E0597: `tmp` does not live long enough
}
