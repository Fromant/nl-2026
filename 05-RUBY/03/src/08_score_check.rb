def validate_score(text)
  score = Integer(text, exception: false)

  return [:error, "not a number"] unless score
  return [:error, "score > 100"] if score > 100
  return [:error, "negative score"] if score < 0

  [:ok, score]
end

puts validate_score("85").inspect
puts validate_score("120").inspect
