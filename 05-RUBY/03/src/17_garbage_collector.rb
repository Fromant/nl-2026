objects = 100_000.times.map { Object.new }
puts "objects created"

objects = nil
GC.start

puts "garbage collection requested"