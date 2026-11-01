threads = 2.times.map do |i|
  Thread.new do
    sleep 0.1
    "task #{i + 1} done"
  end
end

puts "tasks started"
puts threads.map(&:value).sort