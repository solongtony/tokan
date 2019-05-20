require './src/expressions/expression.rb'

# Binary add function
# e.g. add(12, 14)
# This compound expression does not extract any token values itself.
# It uses parser.parse_expression to get it's operands.
class Add
  extend Expression

  attr_reader :rand1
  attr_reader :rand2
  def initialize(rand1, rand2)
    @rand1 = rand1
    @rand2 = rand2
  end

  def self.parse(token_stream, parser)
    gobble(token_stream, :add, 'add', "Expecting 'add' got #{token_stream.peek}")

    gobble(token_stream, :lparen, '(', "Expecting '(' for add got #{token_stream.peek}")

    parser.parse_expression(token_stream)
    rand1 = parser.output_queue.dequeue

    gobble(token_stream, :comma, ',', "Expecting ',' for add got #{token_stream.peek}")

    parser.parse_expression(token_stream)
    rand2 = parser.output_queue.dequeue

    gobble(token_stream, :rparen, ')', "Expecting ')' for add got #{token_stream.peek}")

    parser.output_queue.enqueue(Add.new(rand1, rand2))
  end
end