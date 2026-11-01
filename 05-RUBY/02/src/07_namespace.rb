module University
  class Student
    def initialize(name)
      @name = name
    end

    def label
      "Student: #{@name}"
    end
  end
end

student = University::Student.new("Anna")
puts student.label
