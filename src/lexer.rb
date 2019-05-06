Token = Struct.new(:type, :value)

class Lexer
  attr_reader :word_buffer
  attr_reader :stream
  def initialize(stream)
    @stream = stream
  end

  MATCHERS = {
    add:  /add/,
    val: /val/,
    number: /^[0-9]+$|^[0-9]+\.[0-9]+$/,
    identifier: /^[a-zA-Z_][a-zA-Z0-9_]*$/,
    equals: /=/,
    lparen: /\(/,
    rparen: /\)/
  }

  # discarded from input
  IGNORED_DELIMITERS = '\s'

  # turned into tokens themselves
  KEPT_DELIMITERS = ',=\(\)'

  def self.chop(text)
    # More than one delimiter in a row can create empty tokens.
    text
    .split(%r{#{IGNORED_DELIMITERS}|([#{KEPT_DELIMITERS}])})
    .delete_if { |t| t == "" }
  end

  def next
    if word_buffer.empty?
      word_buffer = chop(stream.read)
    end

    if word_buffer.empty?
      EOF
    else
      tokenize(word_buffer.shift)
    end
  end

  def tokenize(word)
    token = nil
    MATCHERS.each do |type, matcher|
      if  matcher =~ word
        token = Token.new(type, word)
        break
      end
    end
    rais Exception.new("No token type matches #{word}") if token == nil
    token
  end

end