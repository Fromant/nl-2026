// [defines]
// Экспорт символов из библиотеки: собираем с -fvisibility=hidden,
// а наружу открываем только то, что помечено GM_EXPORT.
#define GM_EXPORT __attribute__((visibility("default")))
// [/defines]
