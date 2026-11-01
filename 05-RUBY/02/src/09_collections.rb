require "set"

languages = ["Ruby", "Python"]
languages << "Go"

user = { name: "Alice", age: 20 }
user[:age] += 1

numbers = Set.new([1, 1, 2, 3])

p languages
p user
p numbers
