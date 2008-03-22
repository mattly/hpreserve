require File.dirname(__FILE__) + '/spec_helper.rb'

describe Hpreserve::Variables do
  
  describe "initialization" do
    it "stores the variables in @storage" do
      v = Hpreserve::Variables.new('foo')
      v.instance_variable_get(:@storage).should == 'foo'
    end
  end
  
  describe "retrieval" do
    before do
      @var = Hpreserve::Variables.new({'a' => {'b' => {'c' => 'value'}}})
    end
    
    it "should pull the variables out of the nest" do
      @var['a','b','c'].should == 'value'
      @var[%w(a b c)].should == 'value'
    end
  end
  
end