require './src/expressions/expression.rb'

# Binary add function
# e.g. add(12, 14)
class Add < Expression
  attr_reader :rand1
  attr_reader :rand2
  def initialize(rand1, rand2)
    @rand1 = rand1
    @rand2 = rand2
  end

  def self.matcher
    /add/
  end

  def self.parse(tokens, parser)
    gobble(tokens, 'add', "Expecting 'add' got #{tokens.first}")

    gobble(tokens, '(', "Expecting '(' for add got #{tokens.first}")

    parser.parse_expression(tokens)
    rand1 = parser.output_queue.dequeue

    gobble(tokens, ',', "Expecting ',' for add got #{tokens.first}")

    parser.parse_expression(tokens)
    rand2 = parser.output_queue.dequeue

    gobble(tokens, ')', "Expecting ')' for add got #{tokens.first}")

    parser.output_queue.enqueue(Add.new(rand1, rand2))
  end
end