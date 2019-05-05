#!/usr/bin/env ruby

require './parser.rb'


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
