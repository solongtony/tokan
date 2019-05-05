require './expressions/add.rb'
require './expressions/identifier.rb'
require './expressions/number.rb'
require './expressions/var.rb'

class Parser
  # TODO: track lines and characters.

  MATCHERS = {
    Add.matcher => Add,
    Var.matcher => Var,
    Number.matcher => Number,
    Identifier.matcher => Identifier
  }

  # discarded from input
  IGNORED_DELIMITERS = '\s'
  # turned into tokens themselves
  KEPT_DELIMITERS = ',=\(\)'

  def self.tokenize(text)
    # More than one delimiter in a row can create empty tokens.
    text
    .split(%r{#{IGNORED_DELIMITERS}|([#{KEPT_DELIMITERS}])})
    .delete_if { |t| t == "" }
  end

  def self.parse(tokens)
    #puts "parse #{tokens}"
    node = nil
    MATCHERS.each do |matcher, type|
      #puts "testing #{tokens.first} with #{matcher}"
      if  matcher =~ tokens.first
        #puts "Token #{tokens.first} matches #{matcher}"
        node = type.parse(tokens, self)
        break
      end
    end
    #puts "node #{node}"
    unless node
      raise Exception.new("Failed to parse, next tokens: #{tokens.first(3)}")
    end
    node
  end
end