#!/usr/bin/env ruby

require './src/interpreter.rb'
require './src/parser.rb'

# Parse a code file into a program,
# then execute the program.

program = []

# Each line must be a valid expression, no continued lines.
ARGF.each do |line|
  line.strip!
  next if line.empty?
  tokens = Parser.tokenize(line)
  # puts "tokens #{tokens}"
  program << Parser.parse(tokens)
end

puts "Program:"
program.each { |e| puts e.inspect}
puts

interpreter = Interpreter.new
puts "Output:"
interpreter.execute(program)
puts

puts "Environment:"
puts interpreter.env