class Number
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def self.parse(tokens, parser)
    #puts "Number.parse #{tokens.first}"
    # redundant check, may remove
    if NUMBER_RE =~ tokens.first
      Number.new(tokens.shift)
    else
      raise Exception.new("Invalid number #{tokens.first}")
    end
  end
end