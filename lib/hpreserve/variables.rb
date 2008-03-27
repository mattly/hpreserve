module Hpreserve
  
  class Variables
  
    attr_accessor :storage
  
    def initialize(vars={})
      self.storage = vars
    end
  
    def [](*path)
      stack = @storage
      path.flatten.each do |piece|
        # Hashes
        if stack.respond_to?(:has_key?) and stack.has_key?(piece)
          stack[piece] = stack[piece].call if stack[piece].is_a?(Proc)
          stack = stack[piece]
        else
          return nil
        end
      end
      stack
    end
    
    def string_for(*path)
      value = self[path]
      if value.respond_to?(:has_key?)
        value = value['default']
      end
      value
    end
  
  end
end