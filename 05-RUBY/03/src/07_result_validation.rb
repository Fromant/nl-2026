def parse_score(text)
  score = Integer(text, exception: false)

  if score && (0..100).cover?(score)
    [:ok, score]
  else
    [:error, "score out of range"]
  end
end

result = parse_score("95")
puts result.inspect