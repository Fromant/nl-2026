class Person
  def initialize(name)
    @name = name
  end

  def info
    "Person: #{@name}"
  end
end

class Student < Person
  def initialize(name, group)
    super(name)
    @group = group
  end

  def info
    "#{super}, group: #{@group}"
  end
end

puts Student.new("Max", "30201").info
