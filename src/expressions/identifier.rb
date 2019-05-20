require './src/expressions/expression.rb'

# An identifier is a name.
# The identifier value is pulled from an identifier token.
class Identifier
  extend Expression
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def self.parse(tokens, parser)
    parser.output_queue.enqueue(Identifier.new(tokens.next.value))
  end
end