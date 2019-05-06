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

  def parse(tokens)
    # Using a loop instead of recursion to avoid stack growth.
    # Following tokens may pull values from the return queue.
    while !tokens.empty?
      parse_expression(tokens)
    end

    result = output_queue.dequeue

    unless output_queue.empty?
      puts "Result: #{result}"
      puts "Next output: #{output_queue.peek}"
      puts "Remaining output: #{output_queue.size}"
      puts "Remaining tokens: #{tokens.size}"
      require 'pry'
      binding.pry
      raise Exception.new("Not all output consumed. Remaining output: #{output_queue}")
    end

    result
  end

  # TODO: use a buffered stream of tokens.
  # The parser can look as far ahead as it likes,
  # any token viewed will be cached in the buffer.
  # Results of parsing are pushed onto the output_queue
  def parse_expression(token_queue)
    token = tokens.peek
    expression_class = EXPRESSION_TYPES[token.type]
    unless expression_class
      raise Exception.new("No expression for #{token}")
    end
    # TODO:
    expression_class.parse(tokens, self)
  end

end