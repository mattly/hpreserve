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
    
    it "puss the variables out of the nest" do
      @var['a','b','c'].should == 'value'
      @var[%w(a b c)].should == 'value'
    end
    
    it "doesn't have a problem with non-existant variables" do
      @var[%w(z y x)].should == nil
    end
    
    it "calls proc variables" do
      @var.storage['x'] = proc { 'value' }
      @var['x'].should == 'value'
    end
    
    it "descends into proc variables" do
      @var.storage['x'] = proc { {'a' => 'value'} }
      @var[%w(x a)].should == 'value'
    end
    
    it "descends into datetime variables"
  end
  
end