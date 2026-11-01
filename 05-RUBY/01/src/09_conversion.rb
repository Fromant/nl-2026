# Слайд 9: Приведение типов
# Ruby требует явного преобразования несовместимых типов.

age = "20"

puts age.to_i + 1
puts 42.to_s
puts "3.14".to_f
puts (1..3).to_a.inspect

# "10" + 5 вызвало бы TypeError.
puts "10".to_i + 5
