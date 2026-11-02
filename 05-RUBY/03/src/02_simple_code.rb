def positive(value)
  value >= 0 ? [:ok, value] : [:error, "negative"]
end

puts positive(12).inspect