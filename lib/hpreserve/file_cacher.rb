class Hpreserve::FileCacher < Hpreserve::AbstractCacher
  
  attr_accessor :base_dir
  
  def initialize(patterns, base)
    super(patterns)
    self.base_dir = base
  end
  
  def store(key, value)
    file = File.join(base_dir, key)
    FileUtils.mkdir_p(File.dirname(file)) unless File.directory?(File.dirname(file)) 
    File.open(file, 'w') {|f| f << value }
  end
  
  def retrieve(key)
    file = File.join(base_dir, key)
    File.read(file) if File.exists?(file)
  end
  
  def expire(keys)
    Dir[File.join(base_dir, keys)].each {|f| File.delete(f) }
  end
  
end