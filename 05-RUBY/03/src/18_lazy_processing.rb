result =
  (1..1_000_000)
    .lazy
    .select { |n| n.even? }
    .map { |n| n * n }
    .first(3)

puts result.inspect