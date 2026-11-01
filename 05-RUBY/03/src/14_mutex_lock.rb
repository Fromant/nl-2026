counter = 0
mutex = Mutex.new

threads = 10.times.map do
  Thread.new do
    100.times do
      mutex.synchronize { counter += 1 }
    end
  end
end

threads.each(&:join)
puts counter