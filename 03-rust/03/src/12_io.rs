// Часть 3, слайд 12: «Ввод-вывод: консоль и файлы»

use std::fs::File;
use std::io::{self, BufRead, BufReader, Write};

fn main() -> io::Result<()> {
    // консоль
    print!("Имя: ");
    io::stdout().flush()?;                 // показать приглашение сразу
    let mut name = String::new();
    io::stdin().read_line(&mut name)?;     // дописывает строку в буфер
    println!("Привет, {}!", name.trim());

    // файлы
    let mut f = File::create("notes.txt")?; // создать / перезаписать
    writeln!(f, "первая строка")?;
    writeln!(f, "вторая строка")?;

    let file = File::open("notes.txt")?;
    for line in BufReader::new(file).lines() { // построчное чтение
        println!("> {}", line?);
    }
    Ok(())
}
