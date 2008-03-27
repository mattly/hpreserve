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
    
    it "pulls the variables out of the nest" do
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
    
    it "replaces proc variables with their results, thus calling them only once" do
      i = 0
      @var.storage['x'] = proc { i+=1 }
      3.times { @var['x'] }
      @var['x'].should == 1
    end
    
    it "descends into proc variables" do
      @var.storage['x'] = proc { {'a' => 'value'} }
      @var[%w(x a)].should == 'value'
    end
    
    it "handles date and time variables" do
      time = Time.now
      @var.storage['today'] = time
      @var['today']['default'].should == time.httpdate
      @var['today']['year'].should == time.year
    end
    
    it "knows the size of arrays" do
      @var.storage['x'] = %w(one two three four)
      @var['x','size'].should == 4
    end
    
    it "handles first and last on arrays" do
      @var.storage['x'] = %w(one two three four)
      @var['x','first'].should == 'one'
      @var['x','last'].should == 'four'
    end
    
    it "handles numbers on arrays" do
      @var.storage['x'] = %w(one two three four)
      @var['x','1'].should == 'two'
    end
    
    it "handles procs in arrays" do
      @var.storage['x'] = [proc {'one'}, proc {'two'}]
      @var['x','first'].should == 'one'
      @var['x','1'].should == 'two'
    end
  end
  
  describe "string output" do
    before do
      @var = Hpreserve::Variables.new({'a' => {'b' => {'c' => 'value'}}})
    end
    
    it "appends .default if the given path results in a Hash" do
      @var.storage['a']['default'] = 'default'
      @var.string_for('a').should == 'default'
    end
    
    
  end
  
end