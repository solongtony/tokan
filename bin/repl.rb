#!/usr/bin/env ruby
require "readline"

require './src/interpreter.rb'
require './src/parser.rb'

# Main

parser = Parser.new
interpreter = Interpreter.new

# Each line must be a valid expression, no continued lines.
while line = Readline.readline("> ", true)
  line.strip!
  next if line.empty?

  if line == 'env'
    # A "control command" to show the current environment.
    puts interpreter.env
  else
    # If it's not a control command, parse it as an expression.
    tokens = Parser.tokenize(line)
    expression = parser.parse(tokens)
    begin
      puts interpreter.interpret(expression)
    rescue Exception => e
      puts e.message
    end
  end
end
