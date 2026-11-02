# Примеры к презентации 3

Окружение и способы запуска — см. `../../01/src/README.md` (Docker-образ из `01/src/env`).
Для GCD нужна libdispatch — она ставится скриптом `install-toolchain.sh`.

```bash
make run
# во что компилируется отправка сообщения:
clang $(gnustep-config --objc-flags) -fobjc-arc -S -emit-llvm -O1 11_compiled.m -o - | grep -A3 'define.*callIt'
```

| Файл | Тема |
|---|---|
| `01_threads.m` | NSThread, гонка данных, @synchronized, NSLock, NSCondition |
| `02_gcd.m` | GCD: группы, dispatch_apply, очереди, барьеры, семафоры, dispatch_once |
| `03_operations.m` | NSOperationQueue: зависимости и отмена |
| `04_oop.m` | классы, инициализаторы, наследование, полиморфизм |
| `05_protocols.m` | протоколы, протокол-ориентированный стиль, делегирование |
| `06_categories.m` | категории, ассоциированные объекты, расширения классов |
| `07_functional.m` | map/filter/reduce, композиция, каррирование, NSPredicate |
| `08_messaging.m` | nil, селекторы, NSInvocation, KVC, KVO |
| `09_runtime.m` | интроспекция, isa/метаклассы, IMP, resolve/forwarding, swizzling |
| `10_memory.m`, `10_memory_mrc.m` | циклы удержания, weak, блоки, autoreleasepool, MRC |
| `11_compiled.m` | отправка сообщения = objc_msgSend |

Число в строке `unsafe=...` в выводе `01_threads` меняется от запуска к запуску — это гонка данных.
