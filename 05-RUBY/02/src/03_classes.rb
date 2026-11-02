class Student
  def initialize(name, score)
    @name = name
    @score = score
  end

  def passed?
    @score >= 60
  end
end

student = Student.new("Anna", 92)

puts student.passed?
