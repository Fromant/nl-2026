// Часть 2, слайд 2: «Числа и строки подробнее»

fn main() {
    let a: u8 = 255;               // 0..=255
    let b: i64 = -9_000_000_000;   // _ — разделитель разрядов
    let idx: usize = 3;            // размер указателя: индексы и длины
    let f: f32 = 1.5;
    println!("{a} {b} {idx} {f}");

    let next = a.checked_add(1);   // переполнение → None, а не мусор
    println!("{next:?}");          // None

    let s: String = String::from("привет"); // владеет текстом в куче
    let r: &str = &s;                       // срез: ссылка на чужой текст
    println!("{}", r.len());                // 12 — байты UTF-8
    println!("{}", s.chars().count());      // 6 — символы
}
