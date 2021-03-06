require './src/expressions/expression.rb'

class Identifier < Expression
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def self.matcher
    /^[a-zA-Z_][a-zA-Z0-9_]*$/
  end

  def self.parse(tokens, parser)
    parser.output_queue.enqueue(Identifier.new(tokens.shift))
  end
end