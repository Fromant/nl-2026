// Часть 3, слайд 9: «Traits: общее поведение»

trait Summary {
    fn summary(&self) -> String;
}

struct Article { title: String }
struct Tweet { text: String }

impl Summary for Article {
    fn summary(&self) -> String { format!("Статья: {}", self.title) }
}

impl Summary for Tweet {
    fn summary(&self) -> String { format!("Твит: {}", self.text) }
}

fn print_one<T: Summary>(item: &T) {   // статическая диспетчеризация
    println!("{}", item.summary());
}

fn print_all(items: &[Box<dyn Summary>]) { // динамическая диспетчеризация
    for i in items {
        println!("{}", i.summary());
    }
}

fn main() {
    let a = Article { title: String::from("Rust 2024") };
    print_one(&a);

    let feed: Vec<Box<dyn Summary>> = vec![
        Box::new(a),
        Box::new(Tweet { text: String::from("cargo run!") }),
    ];
    print_all(&feed);
}
