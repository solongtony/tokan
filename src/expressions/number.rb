require './src/expressions/expression.rb'

class Number < Expression
  attr_reader :value
  def initialize(value)
    @value = value
  end

  def self.matcher
    /^[0-9]+$|^[0-9]+\.[0-9]+$/
  end

  def self.parse(tokens, parser)
    parser.output_queue.enqueue(Number.new(tokens.shift))
  end
end