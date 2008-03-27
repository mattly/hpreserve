require File.dirname(__FILE__) + '/spec_helper.rb'

describe Hpreserve::Parser do
  
  describe "includes" do
    before do
      @doc = Hpreserve::Parser.new("<div include='header'> </div>")
      @doc.variables = {'includes' => {'header' => 'value'}}
      @doc.render_includes
    end
    
    it "replaces includes with their content" do
      @doc.doc.at('div').inner_html.should == "value"
    end
    
    it "removes include attribute from the node" do
      @doc.doc.at('div').has_attribute?('include').should be_false
    end
    
    it "handles namespaced includes" do
      @doc = Hpreserve::Parser.new("<div include='contrived.example'> </div>")
      @doc.variables = {'includes' => {'contrived' => {'example' => 'value'}}}
      @doc.render_includes
      @doc.doc.at('div').inner_html.should == "value"
    end
    
    it "uses the include_base attribute" do
      @doc.include_base = 'filesystem'
      @doc.variables = {'filesystem' => {'header' => 'value'}}
      @doc.render_includes
      @doc.doc.at('div').inner_html.should == 'value'
    end
    
  end
  
  describe "simple content replacement" do
    
    before do
      @doc = Hpreserve::Parser.new("Hello <span content='name'>Name</span>.")
      @doc.variables = {'name' => 'Jack'}
      @doc.render_node_content(@doc.doc.at('span'))
    end
    
    it "replaces content= nodes with string content" do
      @doc.doc.to_plain_text.should == "Hello Jack."
    end
    
    it "removes content attributes from the nodes" do
      @doc.doc.at('span').has_attribute?('content').should be_false
    end
  end
  
  describe "content replacement" do
    
    it "ignores nested content attributes" do
      @doc = Hpreserve::Parser.new("Hi <span content='name'><span content='firstname'>Name</span></span>")
      @doc.variables = {'name' => 'Jack Shepherd', 'firstname' => 'Jack'}
      @doc.doc.search('span').each {|n| @doc.render_node_content(n) }
      @doc.doc.to_plain_text.should == "Hi Jack Shepherd"
    end
    
    it "handles variable paths that end up in hashes" do
      @doc = Hpreserve::Parser.new("Hi <span content='name'>Name</span>")
      @doc.variables = {'name' => {'default' => 'Jack Shepherd', 'first' => 'Jack', 'last' => 'Shepherd'}}
      @doc.render_node_content(@doc.doc.at('span'))
      @doc.doc.to_plain_text.should == "Hi Jack Shepherd"
    end
    
  end
  
  describe "collections" do

    it "handles simple collections" do
      @doc = Hpreserve::Parser.new("<ul content='items' local='item'><li content='item'>One</li><li>Another</li></ul>")
      @doc.variables = {'items' => %w(one two three four)}
      @doc.render_node_content(@doc.doc.at('ul'))
      @doc.doc.to_html.should == "<ul><li>one</li><li>two</li><li>three</li><li>four</li></ul>"
    end
    
    it "handles nested collections" do
      @doc = Hpreserve::Parser.new("<ul content='sections' local='section'><li><span content='section.name'>Section</span>: <span content='section.authors' local='author'><span content='author'>Author</span></span></li></ul>")
      @doc.variables = {'sections' => [{'name' => 'one', 'authors' => ['me', 'you']}, {'name' => 'two', 'authors' => ['me']}]}
      @doc.render_node_content(@doc.doc.at('ul'))
      @doc.doc.to_html.should == "<ul><li><span>one</span>: <span><span>me</span><span>you</span></span></li><li><span>two</span>: <span><span>me</span></span></li></ul>"
    end
    
  end
  
  describe "filter handler" do

    it "runs the given filterset on a node" do
      @doc = Hpreserve::Parser.new("<span filter='capitalize'>foo</span>")
      @doc.render_node_filters(@doc.doc.at('span'))
      @doc.doc.at('span').inner_html.should == 'Foo'
    end
    
  end
    
end