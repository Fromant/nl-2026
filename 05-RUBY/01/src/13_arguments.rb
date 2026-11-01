# Слайд 13: Входные данные методов

def greet(name = "World")
  "Hello, #{name}!"
end

def sum(*numbers)
  numbers.sum
end

def user(name:, age:)
  "#{name}, #{age}"
end

puts greet
puts greet("Ruby")

puts sum(1, 2, 3, 4)

puts user(name: "Matz", age: 61)
