#!/usr/bin/env ruby

require './src/interpreter.rb'
require './src/lexer.rb'
require './src/parser.rb'
require './src/token_stream.rb'

# Parse a code file into a program,
# then execute the program.
# Each line must be a valid expression, no continued lines.
# program = []

stream = BufferedTokenStream.new(Lexer, ARGF)
program = Parser.parse_all(stream)

puts "Program:"
program.each { |e| puts e.inspect}
puts

interpreter = Interpreter.new
puts "Output:"
interpreter.execute(program)
puts

puts "Environment:"
puts interpreter.env