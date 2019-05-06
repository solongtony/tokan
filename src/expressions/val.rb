require './src/expressions/expression.rb'

class Val < Expression
  attr_reader :identifier
  attr_reader :value
  def initialize(identifier, value)
    @identifier = identifier
    @value = value
  end

  def self.parse(tokens, parser)
    gobble(tokens, 'val', "Expecting val, got #{tokens.first}")

    Identifier.parse(tokens, parser)
    identifier = parser.output_queue.dequeue

    gobble(tokens, '=', "Expecting '=' for val, got #{tokens.first}")

    parser.parse_expression(tokens)
    value = parser.output_queue.dequeue

    parser.output_queue.enqueue(Val.new(identifier, value))
  end
end