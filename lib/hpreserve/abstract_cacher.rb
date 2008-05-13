module Hpreserve
  class AbstractCacher
    
    attr_accessor :patterns, :storage
    
    def initialize(patterns)
      self.patterns = patterns
    end
    
    def match?(variable)
      pattern = patterns.detect {|p| variable.match(p[:match]) }
      return nil unless pattern
      variable.gsub(pattern[:match], pattern[:key])
    end
    
    
    # overwrite these in your ConcreteCacher to do use whatever you use
    
    def retrieve(key)
      @storage ||= {}
      storage[key]
    end
    
    def store(key, value)
      @storage ||= {}
      storage[key] = value
    end
    
    def expire(pattern)
      @storage ||= {}
      storage.delete_if {|key, value| key.match(pattern) }
    end
    
  end
end