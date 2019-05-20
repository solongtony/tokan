#!/usr/bin/env ruby

require './src/interpreter.rb'
require './src/lexer.rb'
require './src/parser.rb'
require './src/token_stream.rb'

# Parse a code file into a program,
# then execute the program.
# Each line must be a valid expression, no continued lines.
program = []

stream = TokenStream.new(Lexer, ARGF)
while stream.peek != TokenStream::EOF
  begin
    parser = Parser.new
    parser.parse_expression(stream)
    expressions = parser.output_queue
    while expressions.peek
      program << expressions.dequeue
    end
  rescue Exception => e
    puts "Error on line #{stream.line_number}: #{stream.line}"
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