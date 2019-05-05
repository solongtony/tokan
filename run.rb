#!/usr/bin/env ruby

require 'JSON'
require 'set'

# Verify and remove a specific token from tokens.
def gobble(tokens, value, error_message)
  raise Exception.new(error_message) unless tokens.first == value
  tokens.shift
end

# Binary add function
# e.g. add(12, 14)
class Add
  attr_reader :rand1
  attr_reader :rand2

  def initialize(rand1, rand2)
    @rand1 = rand1
    @rand2 = rand2
  end

  def self.parse(tokens, parser)
    gobble(tokens, 'add', "Expecting 'add' got #{tokens.first}")
    gobble(tokens, '(', "Expecting '(' for add got #{tokens.first}")
    rand1 = parser.parse(tokens)
    gobble(tokens, ',', "Expecting ',' for add got #{tokens.first}")
    rand2 = parser.parse(tokens)
    gobble(tokens, ')', "Expecting ')' for add got #{tokens.first}")
    Add.new(rand1, rand2)
  end
end

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

class Var
  attr_reader :name
  attr_reader :value

  def initialize(name, value)
    @name = name
    @value = value
  end

  # def to_s
  #   "#<Var:#{@name},#{@value}>"
  # end

  def self.parse(tokens, parser)
    #parse "Var.parse #{tokens.first(4)}"
    gobble(tokens, 'var', "Expecting var, got #{tokens.first}")

    # TODO: use Identifier.prase for the first token.
    if tokens.first =~ IDENTIFIER_RE
      name = tokens.shift
      #parse "Var.parse name #{name}"
      gobble(tokens, '=', "Expecting '=' for var, got #{tokens.first}")
      value = parser.parse(tokens)
      Var.new(name, value)
    else
      raise Exception.new("Invalid identifier #{tokens.first}")
    end
  end

end

class Number
  attr_reader :value

  def initialize(value)
    @value = value
  end

  # def to_s
  #   "#<Number:#{@value}>"
  # end

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

# Main

filename = ARGV[0]

IDENTIFIER_RE = /^[a-zA-Z_][a-zA-Z0-9_]*$/
NUMBER_RE = /^[0-9]+$|^[0-9]+\.[0-9]+$/

MATCHERS = {
  /add/ => Add,
  /var/ => Var,
  NUMBER_RE => Number,
  IDENTIFIER_RE => Identifier
}

class Parser
  # TODO: track lines and characters.

  attr_reader :program
  def initialize
    @program = []
    #puts "Parser.initialize @program: #{@program}"
  end

  # discarded from input
  IGNORED_DELIMITERS = '\s'
  # turned into tokens themselves
  KEPT_DELIMITERS = ',=\(\)'
  def tokenize(text)
    # More than one delimiter in a row can create empty tokens.
    text
    .split(%r{#{IGNORED_DELIMITERS}|([#{KEPT_DELIMITERS}])})
    .delete_if { |t| t == "" }
  end

  def parse_all(tokens)
    #puts "Parser.parse @program: #{@program}"
    # Using a loop instead of recursion to avoid stack growth.
    #puts "parse #{tokens}"
    while !tokens.empty?
      @program << parse(tokens)
    end
  end

  def parse(tokens)
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

puts "Begin"

parser = Parser.new

# Each line must be a valid expression, no continued lines.
File.open(filename).each do |line|
  tokens = parser.tokenize(line)
  puts "tokens #{tokens}"

  parser.parse_all(tokens)
end

puts "parser.program #{parser.program}"