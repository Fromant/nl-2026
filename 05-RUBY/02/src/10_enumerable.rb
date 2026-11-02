numbers = [1, 2, 3, 4, 5, 6]

evens = numbers.select(&:even?)
squares = evens.map { |n| n**2 }
total = squares.sum

p evens
p squares
puts total
