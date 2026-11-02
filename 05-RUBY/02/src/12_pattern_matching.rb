student = { name: "Alex", score: 92 }

case student
in { name:, score: 90..100 }
  puts "#{name}: excellent"
in { name:, score: 60..89 }
  puts "#{name}: passed"
else
  puts "Not passed"
end
