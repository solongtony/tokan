#!/usr/bin/env ruby

require './interpreter.rb'
require './parser.rb'


# Main

filename = ARGV[0]

program = []

# Each line must be a valid expression, no continued lines.
File.open(filename).each do |line|
  line.strip!
  next if line.empty?
  tokens = Parser.tokenize(line)
  # puts "tokens #{tokens}"
  program << Parser.parse(tokens)
end

puts "Program: #{program}"

interpreter = Interpreter.new
interpreter.execute(program)