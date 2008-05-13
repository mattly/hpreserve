require File.dirname(__FILE__) + '/spec_helper.rb'

describe Hpreserve::AbstractCacher do
  
  it "returns nil if no match for the given variable" do
    cacher = Hpreserve::AbstractCacher.new([])
    cacher.match?('things').should be_nil
  end
  
  it "matches against the given variable and return the key" do
    cacher = Hpreserve::AbstractCacher.new([{:match => %r|^things\.(.*)|, :key => 'thing::\1'}])
    cacher.match?('things.foo').should == 'thing::foo'
  end
  
  it "returns nil if nothing is retrieved from the cache" do
    cacher = Hpreserve::AbstractCacher.new([])
    cacher.storage = {}
    cacher.retrieve('thing::foo').should == nil
  end
  
  it "returns the stored value if it exists" do
    cacher = Hpreserve::AbstractCacher.new([])
    cacher.storage = {'thing::foo' => 'value'}
    cacher.retrieve('thing::foo').should == 'value'
  end
  
  it "sets the value" do
    cacher = Hpreserve::AbstractCacher.new([])
    cacher.storage = {}
    cacher.store('thing::foo', 'value')
    cacher.storage['thing::foo'].should == 'value'
  end
  
  it "expires keys matching a given pattern" do
    cacher = Hpreserve::AbstractCacher.new([])
    cacher.storage = {'thing::foo' => 'foo', 'thing::bar' => 'bar', 'non::thing' => 'bee'}
    cacher.expire(/^thing::.*/)
    cacher.storage.should == {'non::thing' => 'bee'}
  end
  
end