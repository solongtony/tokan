require './src/expressions/expression.rb'

# This compound expression does not extract any token values itself.
# It uses Identifier.parse and parser.parse_expression to get values.
class Val
  extend Expression

  attr_reader :identifier
  attr_reader :value
  def initialize(identifier, value)
    @identifier = identifier
    @value = value
  end

  def self.parse(token_stream, parser)
    gobble(token_stream, :val, 'val', "Expecting val, got #{token_stream.peek}")

    Identifier.parse(token_stream, parser)
    identifier = parser.output_queue.dequeue

    gobble(token_stream, :equals, '=', "Expecting '=' for val, got #{token_stream.peek}")

    parser.parse_expression(token_stream)
    value = parser.output_queue.dequeue

    parser.output_queue.enqueue(Val.new(identifier, value))
  end
end