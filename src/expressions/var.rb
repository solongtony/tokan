require './src/expressions/expression.rb'

class Var < Expression
  attr_reader :identifier
  attr_reader :value
  def initialize(identifier, value)
    @identifier = identifier
    @value = value
  end

  def self.matcher
    /var/
  end

  def self.parse(tokens, parser)
    #parse "Var.parse #{tokens.first(4)}"
    gobble(tokens, 'var', "Expecting var, got #{tokens.first}")
    identifier = Identifier.parse(tokens, parser)
    gobble(tokens, '=', "Expecting '=' for var, got #{tokens.first}")
    value = parser.parse(tokens)
    Var.new(identifier, value)
  end
end