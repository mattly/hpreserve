class Hpreserve::Variables
  
  attr_accessor :storage
  
  def initialize(vars={})
    self.storage = vars
  end
  
  def [](*path)
    stack = @storage
    path.flatten.each do |piece|
      if stack.is_a?(Hash) and stack.has_key?(piece)
        stack[piece] = stack[piece].call if stack[piece].is_a?(Proc)
        stack = stack[piece]
      else
        return nil
      end
    end
    stack
  end
  
end