User = Struct.new(:name)
Product = Struct.new(:name)

def print_name(object)
  puts object.name
end

print_name(User.new("Alice"))
print_name(Product.new("Ruby Book"))
