Token = Struct.new(:type, :value)

# TODO: split out a seperate TokenStream class.

class Lexer
  # Source of lines of text.
  attr_reader :stream
  # Array of chunks which have not been tokenized.
  attr_reader :chunk_buffer
  # Queue of tokens.
  attr_reader :token_buffer
  def initialize(stream)
    @stream = stream
    @chunk_buffer = []
    @token_buffer = RealQueue.new
  end

  EOF = Token.new(:eof, nil)

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

  # Advance the token stream.
  def next
    peek # make sure there is a next element
    token_buffer.shift
  end

  # Look arbitrarily far ahead into the token stream.
  def peek(n = 0)
    while token_buffer.size <= n
      token_buffer << process_chunk
    end
    token_buffer[n]
  end

  private

  # Manages the chunk buffer, reading from the stream as necessary.
  def process_chunk
    if chunk_buffer.empty?
      chunk_buffer = chop(stream.read)
    end

    if chunk_buffer.empty?
      # Tried to get more, there is no more.
      EOF
    else
      tokenize(chunk_buffer.shift)
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