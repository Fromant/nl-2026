class Temperature
  def self.celsius_to_fahrenheit(celsius)
    celsius * 9 / 5.0 + 32
  end
end

puts Temperature.celsius_to_fahrenheit(20)
