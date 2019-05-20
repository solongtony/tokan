require './src/data_structures.rb'
require './src/expressions/add.rb'
require './src/expressions/identifier.rb'
require './src/expressions/number.rb'
require './src/expressions/val.rb'

class Parser
  attr_reader :output_queue
  attr_reader :operator_stack
  def initialize
    @output_queue = RealQueue.new
    @operator_stack = RealStack.new
  end

  EXPRESSION_TYPES = {
    add: Add,
    val: Val,
    number: Number,
    identifier: Identifier
  }

  # def parse(tokens)
  #   # Using a loop instead of recursion to avoid stack growth.
  #   # Following tokens may pull values from the return queue.
  #   while !tokens.empty?
  #     parse_expression(tokens)
  #   end
  #
  #   result = output_queue.dequeue
  #
  #   unless output_queue.empty?
  #     puts "Result: #{result}"
  #     puts "Next output: #{output_queue.peek}"
  #     puts "Remaining output: #{output_queue.size}"
  #     puts "Remaining tokens: #{tokens.size}"
  #     require 'pry'
  #     binding.pry
  #     raise Exception.new("Not all output consumed. Remaining output: #{output_queue}")
  #   end
  #
  #   result
  # end

  # Given a token stream, parse expressions from the stream
  # until there are no more tokens.
  # Return an array of the resulting expressions.
  def self.parse_all(token_stream)
    program = []
    while token_stream.peek != EOF
      begin
        parser = Parser.new
        parser.parse_expression(token_stream)
        program += parser.output_queue.to_a
      rescue Exception => e
        puts "Error on line #{token_stream.line_number}: #{token_stream.line}"
        raise e
      end
    end
    program
  end

  # Uses a buffered stream of tokens.
  # The parser can look as far ahead as it likes,
  # any token viewed will be cached in the buffer.
  # Results of parsing are pushed onto the output_queue
  def parse_expression(token_stream)
    token = token_stream.peek
    expression_class = EXPRESSION_TYPES[token.type]
    unless expression_class
      raise Exception.new("No expression for #{token}")
    end
    expression_class.parse(token_stream, self)
  end
end