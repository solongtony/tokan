#!/usr/bin/env ruby

require './interpreter.rb'
require './parser.rb'

# Verify and remove a specific token from tokens.
def gobble(tokens, value, error_message)
  raise Exception.new(error_message) unless tokens.first == value
  tokens.shift
end


# Main

filename = ARGV[0]

@program = []

# Each line must be a valid expression, no continued lines.
File.open(filename).each do |line|
  tokens = Parser.tokenize(line)
  # puts "tokens #{tokens}"
  @program << Parser.parse(tokens)
end

puts "Program: #{@program}"

interpreter = Interpreter.new
