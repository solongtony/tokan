#!/usr/bin/env ruby

require 'JSON'
require 'set'

require './parser.rb'
require './expressions/add.rb'
require './expressions/identifier.rb'
require './expressions/number.rb'
require './expressions/var.rb'

# Verify and remove a specific token from tokens.
def gobble(tokens, value, error_message)
  raise Exception.new(error_message) unless tokens.first == value
  tokens.shift
end


# Main

filename = ARGV[0]

parser = Parser.new

IDENTIFIER_RE = /^[a-zA-Z_][a-zA-Z0-9_]*$/
NUMBER_RE = /^[0-9]+$|^[0-9]+\.[0-9]+$/

MATCHERS = {
  /add/ => Add,
  /var/ => Var,
  NUMBER_RE => Number,
  IDENTIFIER_RE => Identifier
}

# Each line must be a valid expression, no continued lines.
File.open(filename).each do |line|
  tokens = parser.tokenize(line)
  puts "tokens #{tokens}"
  parser.parse_all(tokens)
end

puts "parser.program #{parser.program}"