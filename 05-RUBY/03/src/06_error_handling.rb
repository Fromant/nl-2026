def parse_positive(text)
  value = Integer(text)
  raise ArgumentError, "negative" if value < 0
  value
end

begin
  puts parse_positive("-7")
rescue ArgumentError => e
  puts e.message
ensure
  puts "finished"
end