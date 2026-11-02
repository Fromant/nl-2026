// Часть 2, слайд 6: «Closures: синтаксис и захват окружения»

fn main() {
    let limit = 10;                    // внешняя переменная
    let add_one = |x: i32| x + 1;      // замыкание — обычное значение
    println!("{}", add_one(4));        // 5

    let small: Vec<i32> = vec![1, 5, 12]
        .iter()
        .copied()                      // &i32 → i32
        .filter(|x| *x < limit)        // захват limit
        .map(add_one)
        .collect();                    // ленивая цепочка выполняется здесь
    println!("{small:?}");             // [2, 6]
}
