def parse_number(text)
  Integer(text)
rescue ArgumentError
  nil
end

puts parse_number("123")