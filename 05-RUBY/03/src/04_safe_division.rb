def divide(a, b)
  raise ZeroDivisionError if b == 0
  a / b
end

puts divide(10, 2)