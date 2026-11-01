def average(values)
  raise ArgumentError, "empty" if values.empty?
  raise "negative value" unless values.all? { |v| v >= 0 }

  result = values.sum.to_f / values.length
  raise "invalid result" if result < 0
  result
end

puts average([80, 90, 100])