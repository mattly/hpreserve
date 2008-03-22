class Hpreserve::Variables
  
  attr_accessor :storage
  
  def initialize(vars={})
    self.storage = vars
  end
  
  # def [](*path)
  #   hash_or_value = @storage
  #   path.each do |piece|
  #     hash_or_value = hash_or_value[piece]
  #   end
  #   hash_or_value
  # end
  
  def [](*path)
    stack = @storage
    path.flatten.each do |piece|
      stack = stack[piece]
    end
    stack
  end
  
  # def []=(*path_and_new_value)
  #   new_value = path_and_new_value.pop
  #   path = path_and_new_value
  #   
  #   hash = @storage
  #   path[0..-2].each do |piece|
  #     hash = hash[piece]
  #   end
  #   hash[path.last] = new_value
  # end
  
end