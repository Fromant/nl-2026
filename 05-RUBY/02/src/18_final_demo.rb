require_relative "17_model"

class Report
  def initialize(items)
    @items = items
  end

  def passed_names
    @items.select(&:passed?).map(&:name)
  end
end

students = [
  Student.new("Anna", 92),
  Student.new("Max", 54),
  Student.new("Eva", 87)
]

report = Report.new(students)

p report.passed_names
