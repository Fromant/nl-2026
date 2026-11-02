// Часть 3, слайд 8: «Оператор ?»

use std::num::ParseIntError;

fn sum(a: &str, b: &str) -> Result<i32, ParseIntError> {
    let x: i32 = a.trim().parse()?;    // Err → сразу return Err
    let y: i32 = b.trim().parse()?;
    Ok(x + y)
}

fn main() {
    println!("{:?}", sum("2", "3"));   // Ok(5)
    println!("{:?}", sum("2", "abc")); // Err(ParseIntError { kind: InvalidDigit })

    let v = sum("4", "5").unwrap();    // ок: 9
    println!("{v}");
    // sum("x", "1").expect("числа");  // паника: unwrap/expect на Err
}
