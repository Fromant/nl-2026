// Часть 2, слайд 15: «Ownership ≈ RAII»

struct Resource {
    name: String,
}

impl Drop for Resource {
    fn drop(&mut self) {
        println!("освобождаю {}", self.name);
    }
}

fn main() {
    let _a = Resource { name: String::from("A") };
    {
        let _b = Resource { name: String::from("B") };
    } // ← освобождаю B
} // конец main ← освобождаю A
