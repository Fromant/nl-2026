class User
  attr_reader :name
  attr_accessor :age

  def initialize(name, age)
    @name = name
    @age = age
  end
end

user = User.new("Alice", 20)
user.age += 1

puts user.name
puts user.age
