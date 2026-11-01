def minmax(numbers)
  [numbers.min, numbers.max]
end

def square(x)
  x * x
end

min, max = minmax([3, 1, 4, 1, 5])

puts "Min: #{min}"
puts "Max: #{max}"
puts "Square: #{square(5)}"
