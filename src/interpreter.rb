class Interpreter
  attr_reader :env
  def initialize(env = {})
    @env = env
  end

  def execute(exp_trees)
    exp_trees.each do |exp|
      puts interpret(exp)
    end
  end

  def interpret(exp)
    # TODO: don't use strings for types
    case exp.class.name
    when 'Add'
      interpret(exp.rand1) + interpret(exp.rand2)
    when 'Identifier'
      val = env[exp.name]
      raise Exception.new("Undefined identifier #{exp.name}") unless val
      val
    when 'Number'
      if exp.value.include?('.')
        exp.value.to_f
      else
        exp.value.to_i
      end
    when 'Val'
      raise Exception.new("Value '#{exp.identifier.name}' already defined") if env.key?(exp.identifier.name)
      env[exp.identifier.name] = interpret(exp.value)
    else
      raise Exception.new("Unkown exp type #{exp.class}")
    end
  end

end