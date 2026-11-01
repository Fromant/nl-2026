def slow_square(x)
  Thread.new do
    sleep 0.2
    x * x
  end
end

future = slow_square(5)
puts "started"
puts future.value