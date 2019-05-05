#!/usr/bin/env ruby

require 'JSON'
require 'set'

require './parser.rb'


# Verify and remove a specific token from tokens.
def gobble(tokens, value, error_message)
  raise Exception.new(error_message) unless tokens.first == value
  tokens.shift
end


# Main

filename = ARGV[0]

parser = Parser.new

# Each line must be a valid expression, no continued lines.
File.open(filename).each do |line|
  tokens = parser.tokenize(line)
  puts "tokens #{tokens}"
  parser.parse_all(tokens)
end

puts "parser.program #{parser.program}"