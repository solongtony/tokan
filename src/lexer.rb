Token = Struct.new(:type, :value)

class Lexer
  # discarded from input
  IGNORED_DELIMITERS = '\s'

  # turned into tokens themselves
  KEPT_DELIMITERS = ',=\(\)'

  # Break a string into chunks based on the defined delimiters.
  def self.chunk(text)
    # More than one delimiter in a row can create empty tokens,
    # so explicitly delting empty strings.
    text
    .split(%r{#{IGNORED_DELIMITERS}|([#{KEPT_DELIMITERS}])})
    .delete_if { |t| t == "" }
  end

  MATCHERS = {
    add:  /add/,
    val: /val/,
    number: /^[0-9]+$|^[0-9]+\.[0-9]+$/,
    identifier: /^[a-zA-Z_][a-zA-Z0-9_]*$/,
    # Make a single punctuation token type?
    comma: /,/,
    equals: /=/,
    lparen: /\(/,
    rparen: /\)/
  }

  # Turn a single chunk into a token.
  def self.tokenize(word)
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