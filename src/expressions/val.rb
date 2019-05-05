require './src/expressions/expression.rb'

class Val < Expression
  attr_reader :identifier
  attr_reader :value
  def initialize(identifier, value)
    @identifier = identifier
    @value = value
  end

  def self.matcher
    /val/
  end

  def self.parse(tokens, parser)
    gobble(tokens, 'val', "Expecting val, got #{tokens.first}")
    identifier = Identifier.parse(tokens, parser)
    gobble(tokens, '=', "Expecting '=' for val, got #{tokens.first}")
    value = parser.parse(tokens)
    Val.new(identifier, value)
  end
end