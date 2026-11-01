File.open("demo.txt", "w") do |file|
  file.puts "one"
  file.puts "two"
  file.puts "three"
end

lines = File.open("demo.txt") do |file|
  file.each_line.map(&:chomp)
end

puts lines.inspect
File.delete("demo.txt")