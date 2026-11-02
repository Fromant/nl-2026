// Часть 2, слайд 4: «Коллекции: Vec, HashMap, HashSet»

use std::collections::{HashMap, HashSet};

fn main() {
    // Vec<T> — динамический массив
    let mut v = vec![1, 2, 3];
    v.push(4);
    v.remove(0);              // [2, 3, 4]
    let first = v[0];         // 2; v[10] — паника
    println!("{v:?} {first} {:?}", v.get(10)); // get(10) → None

    // HashMap<K, V> — значение по ключу
    let mut ages = HashMap::new();
    ages.insert("Анна", 21);
    ages.insert("Олег", 23);
    println!("{:?}", ages.get("Анна")); // Some(21)
    ages.remove("Олег");
    println!("{}", ages.len());          // 1

    // HashSet<T> — множество уникальных значений
    let mut tags = HashSet::new();
    tags.insert("rust");
    tags.insert("rust");                 // дубликат не добавится
    println!("{} {}", tags.contains("rust"), tags.len()); // true 1
}
