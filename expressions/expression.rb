class Expression
  # Helper function used by expressions.
  # Verify and remove a specific token from tokens.
  def self.gobble(tokens, value, error_message)
    raise Exception.new(error_message) unless tokens.first == value
    tokens.shift
  end
end