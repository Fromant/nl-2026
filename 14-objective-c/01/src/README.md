# Примеры к презентации 1

Проверено: Ubuntu 24.04, clang 18, libobjc2 2.3, libdispatch 6.4, GNUstep Make 2.9.3, GNUstep Base 1.31.1.

## Запуск

### Docker (рекомендуется)

```bash
cd 14-objective-c/01/src
docker build -t objc-dev env/                         # один раз, ~5–10 минут
docker run --rm -v "$PWD":/work objc-dev make run     # собрать и запустить всё
docker run --rm -it -v "$PWD":/work objc-dev          # интерактивная оболочка
```

Образ из `env/` подходит и для примеров презентаций 2 и 3:
`docker run --rm -v "$PWD/../../02/src":/work objc-dev make run`.

### Локально (Debian / Ubuntu, а также WSL2 на Windows)

```bash
sudo ./env/install-toolchain.sh     # clang + libobjc2 + libdispatch + GNUstep
make run
```

Быстрый вариант из пакетов (GCC-рантайм: без ARC, блоков и литералов, подходят только `*_mrc.m`):

```bash
sudo apt install gobjc gnustep-devel
. /usr/share/GNUstep/Makefiles/GNUstep.sh   # путь в Debian/Ubuntu; не проверялся в этой сборке
gcc $(gnustep-config --objc-flags) 00_hello_mrc.m $(gnustep-config --base-libs) -o hello
```

### macOS

```bash
clang -fobjc-arc -framework Foundation 05_functions.m -o 05_functions
```

### Онлайн

https://onecompiler.com/objectivec — clang 7 + GNUstep, ARC выключен, блоки запрещены.
Подходят `00_hello_mrc.m`, `04_ownership_mrc.m`.

## Файлы

| Файл | Тема |
|---|---|
| `00_hello_mrc.m`, `00_hello_arc.m` | первая программа (классический и современный стиль) |
| `01_types.m` | типы данных, литералы, операции |
| `02_casts.m` | преобразование и приведение типов |
| `03_scope.m` | области видимости, видимость ivar |
| `04_ownership.m`, `04_ownership_mrc.m` | владение: ARC и ручной подсчёт ссылок |
| `05_functions.m` | функции и методы: вход и выход, NSError |
| `06_recursion.m` | рекурсия, мемоизация, рекурсивный блок |
| `07_blocks.m` | замыкания (блоки) |
| `08_control.m` | условия, switch, циклы |
| `09_iterators.m` | for-in, NSEnumerator, перебор блоками, свой итератор |

Фрагменты, показанные на слайдах, отмечены в коде комментариями `// [имя]` … `// [/имя]`.
