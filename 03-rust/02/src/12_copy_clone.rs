// Часть 2, слайд 12: «Copy и Clone»

fn main() {
    let x: i32 = 10;
    let y = x;                 // Copy: побитовая копия
    println!("{x} {y}");       // обе доступны

    let s1 = String::from("hi");
    let s2 = s1.clone();       // Clone: новый буфер в куче
    println!("{s1} {s2}");     // обе доступны

    let r1 = &s1;
    let r2 = r1;               // &T тоже Copy, хотя данные в куче
    println!("{r1} {r2}");
}
