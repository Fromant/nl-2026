# Слайд 10: Области видимости
# name — локальная, $name — глобальная, @name — экземпляра,
# @@name — класса, NAME — константа.

x = 10

1.times do
  x = 20
  y = 30

  puts "Inside: x = #{x}, y = #{y}"
end

puts "Outside: x = #{x}"

# Переменная y была создана внутри блока и снаружи недоступна:
# puts y # NameError
