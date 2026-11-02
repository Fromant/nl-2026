# ==========================================
# Слайд 3: Объектно-ориентированный подход: struct
# ==========================================
struct Rectangle:
    var width: Float64
    var height: Float64
    var _scale_count: Int

    def __init__(out self, width: Float64, height: Float64):
        self.width = width
        self.height = height
        self._scale_count = 0

    def area(self) -> Float64:
        return self.width * self.height

    def scale(mut self, factor: Float64):
        self.width *= factor
        self.height *= factor
        self._scale_count += 1

def main():
    var r = Rectangle(3.0, 4.0)
    print("Площадь:", r.area())
    r.scale(2.0)
    print("После scale:", r.area())
    print("Вызовов scale:", r._scale_count)


# ==========================================
# Слайд 4: Trait — контракт поведения
# ==========================================
trait Shape:
    def area(self) -> Float64:
        ...
    def perimeter(self) -> Float64:
        ...

struct Rectangle(Shape):
    var width: Float64
    var height: Float64

    def __init__(out self, width: Float64, height: Float64):
        self.width = width
        self.height = height

    def area(self) -> Float64:
        return self.width * self.height

    def perimeter(self) -> Float64:
        return 2 * (self.width + self.height)


def describe[T: Shape](shape: T):
    print("Площадь:", shape.area(), "Периметр:", shape.perimeter())


def main():
    var r = Rectangle(3.0, 4.0)
    describe(r)


# ==========================================
# Слайд 5: Refinement и композиция трейтов
# ==========================================
trait Shape:
    def area(self) -> Float64:
        ...

trait NamedShape(Shape):  # наследуем Shape
    def name(self) -> String:
        ...

struct Circle(NamedShape):
    var radius: Float64
    def area(self) -> Float64:
        return 3.14159 * self.radius ** 2
    def name(self) -> String:
        return "Circle"

def print_info[T: Shape & Copyable](shape: T):  # композиция трейтов
    print(shape.area())

# Функции первого класса
def double(x: Int) -> Int:
    return x * 2

def apply[F: def(Int) -> Int, //](f: F, x: Int) -> Int:
    return f(x)

def main():
    print(apply(double, 5))  # 10


# ==========================================
# Слайд 6: Параметризованные функции: [] vs ()
# ==========================================
def max_value[T: Comparable & Copyable](a: T, b: T) -> T:
    if a > b:
        return a.copy()
    return b.copy()

def main():
    print(max_value(3, 7))          # T выведен как Int
    print(max_value("a", "b"))      # T выведен как String
    print(max_value(3.0, 4))        # T выведен как Float64, 4 -> 4.0
    # print(max_value(4, 3.0))      # ошибка компиляции: T уже Int, Float -> Int неявно не работает


# ==========================================
# Слайд 7: Параметризованные типы: Pair[T]
# ==========================================
struct Pair[T: Comparable & Copyable]:
    var left: Self.T
    var right: Self.T

    def __init__(out self, left: Self.T, right: Self.T):
        self.left = left.copy()
        self.right = right.copy()

    def max(self) -> Self.T:
        if self.left > self.right:
            return self.left.copy()
        return self.right.copy()


def main():
    var p = Pair[Int](3, 7)
    print(p.max())


# ==========================================
# Слайд 8: Гибкие ограничения на типы
# ==========================================
def show(x: Some[Writable]):
    print(x)


struct Box[T: Copyable]:
    var value: Self.T

    def print_if_writable(self) where conforms_to(Self.T, Writable):
        print(self.value)


# ==========================================
# Слайд 9: Обработка ошибок в Мојо
# ==========================================
def divide(a: Int, b: Int) raises -> Int:
    if b == 0:
        raise Error("деление на ноль")
    if b < 0:
        raise Error("делитель не может быть отрицательным")
    return a // b

def average(a: Int, b: Int, c: Int) raises -> Int:
    return divide(a + b + c, 3)

def halve(a: Int) -> Int:
    return a // 2


# ==========================================
# Слайд 10: Перехват ошибок и проверки
# ==========================================
var result: Int
try:
    result = divide(10, 0)
except e:
    print("Ошибка:", e)
else:
    print("Успех:", result)
finally:
    print("Готово")

debug_assert(b != 0, "b не должен быть нулём")


# ==========================================
# Слайд 11: Управление сложностью: модули
# ==========================================
# mymodule.mojo
struct MyPair:
    var first: Int
    var second: Int


# main.mojo
from mymodule import MyPair
from mymodule import MyPair as Pair
import mymodule as m

def main():
    var p = MyPair(2, 4)
    var p3 = Pair(5, 6)
    var p2 = m.MyPair(1, 1)


# ==========================================
# Слайд 12: Пакеты: __init__.mojo
# ==========================================
# Структура пакета:
# main.mojo
# mypackage/
#     __init__.mojo
#     mymodule.mojo

# mypackage/__init__.mojo
from .mymodule import MyPair

# main.mojo
from mypackage import MyPair # через ре-экспорт
# from mypackage.mymodule import MyPair
# или напрямую, по полному пути – тоже сработает

def main():
    var p = MyPair(2, 4)

# Консольная команда (mojo precompile mypackage -o mypack.mojoc)
# и импорт: from mypack import MyPair