# main.rb — единая точка входа для примеров со слайдов 6–13.
# Запуск из этой папки: ruby main.rb

files = %w[
  06_hello
  07_types
  08_operations
  09_conversion
  10_scope
  11_objects
  12_methods
  13_arguments
]

files.each do |name|
  puts "\n########## #{name} ##########\n\n"
  load File.join(__dir__, "#{name}.rb")
end
