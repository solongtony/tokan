#!/usr/bin/env ruby
require "readline"

require './src/interpreter.rb'
require './src/parser.rb'

# Main

interpreter = Interpreter.new

# Each line must be a valid expression, no continued lines.
while line = Readline.readline("> ", true)
  line.strip!
  next if line.empty?
  if line == 'env'
    puts interpreter.env
  else
    tokens = Parser.tokenize(line)
    expression = Parser.parse(tokens)
    begin
      puts interpreter.interpret(expression)
    rescue Exception => e
      puts e.message
    end
  end
end
