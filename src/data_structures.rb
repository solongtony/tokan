# The problem with using Ruby Arrays as stacks and queues is they have too much functionality.
# If you call the wrong method, you will break the expected FIFO or FILO behavior.
# These implementations Use Arrays, but restrict the operations that can be used to enforce Stack and Queue Semantics.

# These implementations cannot store nil, nil is used to indicate no values remain.

# Modified from these examples
# https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/33-advanced-arrays/lessons/86-stacks-and-queues
# https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/33-advanced-arrays/lessons/86-stacks-and-queues#solution4117
# https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/33-advanced-arrays/lessons/86-stacks-and-queues#solution4121

# The name Queue conflicts with Ruby's thread safe Queue, so using odd names.

class RealStack
  def initialize
    @store = Array.new
  end

  # Remove from the end of the array.
  def pop
    @store.pop
  end

  # Add to the the end of the array.
  def push(element)
    @store.push(element)
    self
  end

  def size
    @store.size
  end

  def peek
    @store[@top]
  end
end

class RealQueue
  def initialize
    @store = Array.new
  end

  # Remove from the end of the array.
  def dequeue
    @store.pop
  end

  # Add to the beginning of the array.
  def enqueue(element)
    if element.class.name == "RealQueue"
      require 'pry'
      binding.pry
    end
    @store.unshift(element)
    self
  end

  def size
    @store.size
  end

  def peek
    @store.last
  end

  def empty?
    peek == nil
  end
end