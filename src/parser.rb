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

  MATCHERS = {
    Add.matcher => Add,
    Val.matcher => Val,
    Number.matcher => Number,
    Identifier.matcher => Identifier
  }

  # discarded from input
  IGNORED_DELIMITERS = '\s'

  # turned into tokens themselves
  KEPT_DELIMITERS = ',=\(\)'

  def self.tokenize(text)
    # More than one delimiter in a row can create empty tokens.
    text
    .split(%r{#{IGNORED_DELIMITERS}|([#{KEPT_DELIMITERS}])})
    .delete_if { |t| t == "" }
  end

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

  # Results of parsing are pushed onto the output_queue
  def parse_expression(tokens)
    # node = nil
    found_matcher = false
    MATCHERS.each do |matcher, type|
      if  matcher =~ tokens.first
        type.parse(tokens, self)
        found_matcher = true
        break
      end
    end

    unless found_matcher
      raise Exception.new("No token matcher matched #{tokens.first}")
    end

    # unless node
    #   raise Exception.new("Failed to parse, next tokens: #{tokens.first(3)}")
    # end
    #
    # output_queue.enqueue(node)
  end
end