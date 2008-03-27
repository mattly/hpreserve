module Hpreserve
  
  class Variables
  
    attr_accessor :storage
  
    def initialize(vars={})
      self.storage = vars
    end
    
    # climbs the branches of the variable hash's tree, handling non-hashes along the way.
    def [](*path)
      stack = @storage
      path.flatten.each do |piece|
        # much of this stolen blatantly from liquid
        if (stack.respond_to?(:has_key?) and stack.has_key?(piece)) ||
           (stack.respond_to?(:fetch) and piece =~ /^\d+$/)
          piece = piece.to_i if piece =~ /^\d+$/
          stack[piece] = stack[piece].to_hpreserve if stack[piece].respond_to?(:to_hpreserve)
          stack = stack[piece]
        elsif %w(first last size).include?(piece) and stack.respond_to?(piece)
          item = stack.send(piece)
          stack = item.respond_to?(:to_hpreserve) ? item.to_hpreserve : item
        else
          return nil
        end
      end
      stack
    end
    
  end
end