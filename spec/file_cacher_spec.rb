require 'tmpdir'
require 'digest/md5'
require File.dirname(__FILE__) + '/spec_helper.rb'

describe Hpreserve::FileCacher do
  
  before do
    @cacher = Hpreserve::FileCacher.new([], Dir.tmpdir)
    @key = Digest::MD5.hexdigest("#{Time.now}--#{inspect}")
  end
  
  it "knows about its base directory" do
    @cacher.patterns.should == []
    @cacher.base_dir.should == Dir.tmpdir
  end
  
  it "stores values in files matching the key" do
    @cacher.store(@key, 'new value')
    File.should be_file(File.join(Dir.tmpdir, @key))
    File.read(File.join(Dir.tmpdir, @key)).should == 'new value'
  end
  
  it "creates directories as needed if they don't exist" do
    @cacher.store("#{@key}/foo", 'new value')
    File.should be_directory(File.join(Dir.tmpdir, @key))
    File.should be_file(File.join(Dir.tmpdir, @key, 'foo'))
  end
  
  it "retrieves values from files matching the key" do
    File.open(File.join(Dir.tmpdir, @key), 'w') {|f| f << 'existing value'}
    @cacher.retrieve(@key).should == 'existing value'
  end
  
  it "returns nil when retrieving a key for a file that doens't exist" do
    File.should_not be_file(File.join(Dir.tmpdir, @key))
    @cacher.retrieve(@key).should be_nil
  end
  
  it "deletes files when expiring keys" do
    files = [1,2].collect {|i| File.join(Dir.tmpdir, "#{@key}-#{i}") }
    files.each {|file| File.open(file, 'w') {|f| f << 'hi'} }
    @cacher.expire("#{@key}*")
    files.each {|file| File.should_not be_file(file)}
  end
  
end