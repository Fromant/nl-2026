code = "x = 1 + 2"
iseq = RubyVM::InstructionSequence.compile(code)

puts iseq.class
puts iseq.disasm.lines.first(5)
