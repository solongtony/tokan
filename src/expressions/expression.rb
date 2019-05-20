module Expression
  # extend Expression instead of including it.

  # Helper function used by expressions.
  # Verify and remove a specific token from tokens.
  def gobble(tokens, type, value, error_message)
    raise Exception.new(error_message) unless tokens.peek.value == value
    tokens.next
  end
end