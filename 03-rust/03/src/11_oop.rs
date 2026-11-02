// Часть 3, слайд 11: «ООП, ФП и протоколы в Rust»

mod stats {
    pub struct Counter {
        value: u32,                    // приватное поле — инкапсуляция
    }

    impl Counter {
        pub fn new() -> Self { Counter { value: 0 } }
        pub fn inc(&mut self) { self.value += 1; }
        pub fn get(&self) -> u32 { self.value }
    }
}

struct Clicker {
    counter: stats::Counter,           // композиция вместо наследования
}

fn main() {
    let mut c = Clicker { counter: stats::Counter::new() };
    c.counter.inc();
    c.counter.inc();
    println!("{}", c.counter.get());   // 2
    // c.counter.value = 10;           // E0616: field `value` is private

    // ФП: та же задача через итератор
    let evens = (0..5).filter(|n| n % 2 == 0).count();
    println!("{evens}");               // 3
}
