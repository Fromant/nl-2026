// Часть 3, слайд 13: «Concurrency: потоки, каналы, общая память»

use std::sync::{mpsc, Arc, Mutex};
use std::thread;

fn main() {
    // общая память: Arc + Mutex
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];
    for _ in 0..4 {
        let c = Arc::clone(&counter);
        handles.push(thread::spawn(move || {
            *c.lock().unwrap() += 1;
        }));
    }
    for h in handles {
        h.join().unwrap();                 // Err, если поток запаниковал
    }
    println!("{}", *counter.lock().unwrap()); // 4

    // сообщения: канал
    let (tx, rx) = mpsc::channel();
    thread::spawn(move || tx.send("готово").unwrap());
    println!("{}", rx.recv().unwrap());

    // Rc нельзя отправить в поток:
    // let rc = std::rc::Rc::new(1);
    // thread::spawn(move || println!("{rc}"));
    // E0277: `Rc<i32>` cannot be sent between threads safely
}
