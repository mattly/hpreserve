module Hpreserve
  
  # 
  
  # Acts as a sandbox to run filters in, most everything except the self.parse method
  # was stolen from Liquid's Strainer class. Almost all the standard class methods
  # (especially instance_eval) are undefined, and respond_to? is modified to only
  # return true on methods defined by the filter modules registered.
  class Filters
    
    @@filter_modules = []
    
    def self.register(filterset)
      [filterset].flatten.each do |mod|
        raise StandardError("passed filter is not a module") unless mod.is_a?(Module)
        @@filter_modules << mod
      end
    end
    
    def self.create
      filterset = Filters.new
      @@filter_modules.each { |m| filterset.extend m }
      filterset
    end
    
    def self.parse(str='')
      str.split(';').inject([]) do |memo, rule|
        list = rule.split(':')
        filter = list.shift.strip
        set = [filter]
        set << list.join(':').strip unless list.empty?
        memo << set
      end
    end
    
    @@required_methods = %w(__send__ __id__ inspect methods respond_to? extend)
    
    # :nodoc
    # keeping inspect around simply to make irb happy.
    def inspect; end

    def respond_to?(method)
      method_name = method.to_s
      return false if method_name =~ /^__/ 
      return false if @@required_methods.include?(method_name)
      super
    end

    instance_methods.each do |m| 
      unless @@required_methods.include?(m) 
        undef_method m 
      end
    end
    
  end
end