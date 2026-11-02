def load_name(id)
  Thread.new { "student-#{id}" }
end

def load_score(id)
  Thread.new { 70 + id }
end

name = load_name(3)
score = load_score(3)

puts "#{name.value}: #{score.value}"

threads = [1, 2, 3].map { |id| load_score(id) }
puts threads.map(&:value).inspect