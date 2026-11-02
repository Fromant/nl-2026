def counter
  count = 0

  -> {
    count += 1
  }
end

counter1 = counter

puts counter1.call
puts counter1.call
puts counter1.call

double = Proc.new { |x| x * 2 }

puts double.call(5)

