// Часть 2, слайд 5: «Итераторы: три способа и next()»

fn main() {
    let mut v = vec![10, 20, 30];

    for x in v.iter() {        // &i32 — только читаем
        println!("{x}");
    }
    for x in v.iter_mut() {    // &mut i32 — меняем на месте
        *x += 1;
    }

    let mut it = v.iter();     // next() вручную
    println!("{:?}", it.next()); // Some(11)
    println!("{:?}", it.next()); // Some(21)

    for x in v.into_iter() {   // i32 — забирает элементы
        println!("{x}");
    }
    // println!("{v:?}");      // E0382: v уже потреблён
}
