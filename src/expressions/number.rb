require './src/expressions/expression.rb'

# The numeric value is pulled from a number token.
class Number
  extend Expression
  attr_reader :value
  def initialize(value)
    @value = value
  end

  def self.parse(tokens, parser)
    parser.output_queue.enqueue(Number.new(tokens.next.value))
  end
end