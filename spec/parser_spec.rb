require File.dirname(__FILE__) + '/spec_helper.rb'

describe Hpreserve::Parser do
  
  describe "simple content replacement" do
    
    before do
      @doc = Hpreserve::Parser.new("Hello <span content='name'>Name</span>.")
      @doc.variables = {'name' => 'Jack'}
      @doc.render_content
    end
    
    it "replaces content= nodes with string content" do
      @doc.doc.to_plain_text.should == "Hello Jack."
    end
    
    it "removes content attributes from the nodes" do
      @doc.doc.to_s.should == 'Hello <span>Jack</span>.'
    end
  end
  
  describe "content replacement" do
    
    it "ignores nested content attributes" do
      @doc = Hpreserve::Parser.new("Hi <span content='name'><span content='firstname'>Name</span></span>")
      @doc.variables = {'name' => 'Jack Shepherd', 'firstname' => 'Jack'}
      @doc.render_content
      @doc.doc.to_plain_text.should == "Hi Jack Shepherd"
    end
    
  end
  
  describe "wrapper replacement" do
    it "replaces wrapper elements with their contents" do
      @doc = Hpreserve::Parser.new("a <wrapper>b</wrapper> c")
      @doc.replace_wrappers
      @doc.doc.to_s.should == "a b c"
    end
  end
  
  describe "filter handler" do

    it "runs the given filterset on a node" do
      @doc = Hpreserve::Parser.new("<span filter='capitalize'>foo</span>")
      @doc.run_filters
      @doc.doc.at('span').inner_html.should == 'Foo'
    end
    
  end
    
end