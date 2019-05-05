#!/usr/bin/env ruby

require './src/interpreter.rb'
require './src/parser.rb'

# Parse a code file into a program,
# then execute the program.
# Each line must be a valid expression, no continued lines.

program = []
line_number = 0

ARGF.each do |line|
  begin
    line_number += 1
    line.strip!
    next if line.empty?

    tokens = Parser.tokenize(line)
    parser = Parser.new
    program << parser.parse(tokens)
  rescue Exception => e
    puts "Error on line #{line_number}: #{line}"
    raise e
  end
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