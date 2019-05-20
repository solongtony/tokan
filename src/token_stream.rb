EOF = Token.new(:eof, nil)

# A simple token stream Initialized with an array of tokens.
class TokenStream
  # For error reporting.
  attr_reader :line_number
  # There isn't a line of text here, so use the token.
  attr_reader :line
  def initialize(tokens)
    @tokens = tokens
    @line_number = 0
  end

  def next
    @line_number += 1
    @line = @tokens.shift || EOF
  end

  def peek
    @line = @tokens.first || EOF
  end
end

# Takes a lexer and a text stream.
# The text stream should have a `read` method which returns one line of text.
# Lines of text are chunked into an array of words and stored in a buffer.
# The next token is consumed with `next`
# Upcoming tokens can be inspected arbitrarily far ahead with `peek(n)`
# Any token which has been created but not consumed is stored in a token buffer.
class BufferedTokenStream
  # Source of lines of text.
  # attr_reader :stream
  # Array of chunks which have not been tokenized.
  # attr_reader :chunk_buffer
  # Array of tokens made from chunks.
  # attr_reader :token_buffer

  # For error reporting.
  attr_reader :line_number
  attr_reader :line
  def initialize(lexer, stream)
    @lexer = lexer
    @stream = stream
    @chunk_buffer = []
    @token_buffer = []
    @line_number = 0
  end

  # Advance the token stream.
  def next
    peek # make sure there is a next element
    @token_buffer.shift
  end

  # Look arbitrarily far ahead into the token stream.
  def peek(n = 0)
    while @token_buffer.size <= n
      @token_buffer << process_chunk
    end
    @token_buffer[n]
  end

  private

  # Manages the chunk buffer, reading from the stream as necessary.
  def process_chunk
    if @chunk_buffer.empty?
      loop do
        @line_number += 1
        break unless (@line = @stream.read) == ""
      end
      @chunk_buffer = @lexer.chunk(@line) unless @line == nil
    end

    if @chunk_buffer.empty?
      # Tried to get more, there is no more.
      EOF
    else

      @lexer.tokenize(@chunk_buffer.shift)
    end
  end
end