#!/usr/bin/env ruby
require "readline"

require './src/interpreter.rb'
require './src/lexer.rb'
require './src/parser.rb'
require './src/token_stream.rb'

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
    # Each line must be a complete expression, no multi-line expressions.
    chunks = Lexer.chunk(line)
    tokens = chunks.map { |chunk| Lexer.tokenize(chunk) }
    #expression = parser.parse_expression(TokenStream.new(tokens))
    expressions = Parser.parse_all(TokenStream.new(tokens))

    expressions.each do |expression|
      begin
        puts expression.inspect
        puts interpreter.interpret(expression)
      rescue Exception => e
        puts e.message
      end
    end
  end
end
