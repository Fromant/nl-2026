# Примеры к презентации 2

Окружение и способы запуска — см. `../../01/src/README.md` (Docker-образ из `01/src/env`).

```bash
make run                                  # все примеры
./01_exceptions x                         # + необработанное исключение
./03_assert c                             # + срабатывание assert() из C
printf "3\n5\nabc\n10\n" | ./08_console   # консольный ввод
cd 04_modules && make && ./app_static && ./app_shared && ./app_modules
cd 04_modules && make exports             # экспортируемые символы libGeometry.so
cd 04_modules && make -f gnustep.mk && ./obj/geometry_demo   # то же на GNUstep Make
```

| Файл | Тема |
|---|---|
| `01_exceptions.m` | @try/@catch/@finally, свои исключения, обработчик необработанных |
| `02_errors.m` | NSError: домен, код, userInfo, цепочка причин |
| `03_assert.m` | assert, NSAssert, NSParameterAssert, NSCAssert, отладочный макрос |
| `04_modules/` | префиксы, .h/.m, экспорт и видимость, .a/.so, @import, GNUstep Make |
| `05_generics.m` | lightweight generics: декларация, ограничения, __kindof, стирание |
| `06_collections.m` | NSArray, NSSet, NSCountedSet, NSOrderedSet, NSDictionary, NSNull, NSValue |
| `07_files.m` | запись и чтение файлов, NSFileManager, JSON |
| `08_console.m` | консольный ввод-вывод |

Замечание о GNUstep: `-[NSString stringWithContentsOfFile:encoding:error:]` при отсутствии
файла возвращает nil, но не заполняет NSError (в Apple Foundation заполняет).
