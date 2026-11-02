def validate_number(n)
  n >= 0 ? [:ok, n] : [:error, "negative"]
end

puts validate_number(-5).inspect