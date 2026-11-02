def parse_line(line)
  name, score_text = line.split(",", 2)
  return [:error, "invalid line"] unless name && score_text

  score = Integer(score_text, exception: false)
  return [:error, "invalid score"] unless score && (0..100).cover?(score)

  [:ok, { name: name, score: score }]
end

input = ["Ann,90", "Bob,75", "Cara,82"]
parsed = input.map { |line| parse_line(line) }

raise "input error" if parsed.any? { |r| r[0] == :error }

students = parsed.map { |r| r[1] }
raise "empty data" if students.empty?

average = students.sum { |s| s[:score] }.to_f / students.length
raise "invalid average" unless average >= 0

reports = [
  Thread.new { "average=#{average}" },
  Thread.new { "passed=#{students.count { |s| s[:score] >= 60 }}" }
]

puts reports.map(&:value).inspect