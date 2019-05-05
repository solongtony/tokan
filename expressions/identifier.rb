class Identifier
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.parse(tokens, parser)
    name = nil
    if tokens.first =~ IDENTIFIER_RE
      name = tokens.shift
    else
      raise Exception.new("Invalid identifier #{tokens.first}")
    end
    Identifier.new(name)
  end
end