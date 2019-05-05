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
    @program
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