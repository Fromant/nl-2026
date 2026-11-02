module Passable
  def passed?
    score >= 60
  end
end

class Student
  include Passable

  attr_reader :name, :score

  def initialize(name, score)
    @name = name
    @score = score
  end
end
