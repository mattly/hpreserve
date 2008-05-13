require File.dirname(__FILE__) + '/spec_helper.rb'

describe Hpreserve::Parser do
  
  describe "includes" do
    before do
      @doc = Hpreserve::Parser.new("<div include='header'> </div>")
      @doc.variables = {'header' => 'value'}
      @doc.render_includes
    end
    
    it "replaces includes with their content" do
      @doc.doc.at('div').inner_html.should == "value"
    end
    
    it "removes include attribute from the node" do
      @doc.doc.at('div').has_attribute?('include').should be_false
    end
    
    it "handles namespaced includes" do
      @doc.doc = Hpricot("<div include='contrived.example'> </div>")
      @doc.variables = {'contrived' => {'example' => 'value'}}
      @doc.render_includes
      @doc.doc.at('div').inner_html.should == "value"
    end
    
    it "uses the include_base attribute" do
      @doc.include_base = 'filesystem'
      @doc.variables = {'filesystem' => {'header' => 'value'}}
      @doc.render_includes
      @doc.doc.at('div').inner_html.should == 'value'
    end
    
    it "substitutes variables in the include string" do
      @doc.doc = Hpricot("<div include='{a}_sidebar'> </div>")
      @doc.variables = {'a' => 'b', 'b_sidebar' => 'value'}
      @doc.render_includes
      @doc.doc.at('div').inner_html.should == 'value'
    end
    
    it "ignores a default include if the given include exists" do
      @doc.doc = Hpricot("<div include='{a}_sidebar | sidebar'> </div>")
      @doc.variables = {'a' => 'a', 'a_sidebar' => 'value'}
      @doc.render_includes
      @doc.doc.at('div').inner_html.should == 'value'
    end
    
    it "falls back to a default include if the given value returns empty" do
      @doc.doc = Hpricot("<div include='{a}_sidebar | sidebar'> </div>")
      @doc.variables = {'a' => 'b', 'sidebar' => 'value'}
      @doc.render_includes
      @doc.doc.at('div').inner_html.should == 'value'
    end
    
    it "doesn't care about whitespace (or lack of) in the include directive" do
      @doc.variables = {'a' => 'a', 'a_sidebar' => 'a_value', 'sidebar' => 'value'}
      
      ["{a}_sidebar|sidebar", " {a}_sidebar | sidebar ", "   {a}_sidebar  "].each do |i|
        @doc.doc = Hpricot("<div include='#{i}'> </div>")
        @doc.render_includes
        @doc.doc.at('div').inner_html.should == 'a_value'
      end
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
    
    it "ignores whitespace in variable names" do
      @doc = Hpreserve::Parser.new("Hi <span content='  name  '>Name</span>")
      @doc.variables = {'name' => 'Jack Shepherd'}
      @doc.render_node_content(@doc.doc.at('span'))
      @doc.doc.to_plain_text.should == 'Hi Jack Shepherd'
    end
    
    describe "on meta tags" do
      before do
        @doc = Hpreserve::Parser.new("<head><meta name='foo' content='plain content' /><meta name='bar'  content='{bar}' /></head>")
        @doc.variables = {'bar' => 'value'}
        @doc.render
      end
      
      it "does not insert the content into the node" do
        @doc.doc.at('meta[@name=foo]').inner_html.should == ''
        @doc.doc.at('meta[@name=bar]').inner_html.should == ''
      end
      
      it "ignores lack of variables in content string" do
        @doc.doc.at('meta[@name=foo]')['content'].should == 'plain content'
      end
      
      it "substitutes variables in content string" do
        @doc.doc.at('meta[@name=bar]')['content'].should == 'value'
      end
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
    
    it "handles whitespace" do
      @doc = Hpreserve::Parser.new("<ul content='items' local='item'>

        <li content='item'>1</li>

      </ul>")
      @doc.variables = {'items' => ['one']}
      @doc.render_node_content(@doc.doc.at('ul'))
      @doc.doc.to_html.should == "<ul><li>one</li></ul>"
    end
    
  end
  
  describe "caching" do
    before do
      @doc = Hpreserve::Parser.new("<span content='some.thing'>non-rendered</span>")
      @doc.variables = {'some' => {'thing' => 'from variables'}}
      cacher_matches([{:match => /^some\.thing/, :key => 'something'}])
    end
    
    def cacher_matches(match=[])
      @doc.cacher = Hpreserve::AbstractCacher.new(match)
    end
    
    def render
      @doc.render_node_content(@doc.doc.at('span'))
    end
    
    it "ignores the cacher if no match is found" do
      cacher_matches()
      render
      @doc.doc.to_s.should == '<span>from variables</span>'
    end
    
    it "checks the cache if a match is found" do
      @doc.cacher.should_receive(:retrieve).with('something')
      render
    end
    
    it "uses the value from the cache if a match is found and the key exists in the cache" do
      @doc.cacher.store('something', 'from cacher')
      render
      @doc.doc.to_s.should == 'from cacher'
    end
    
    it "does not render if a match is found and the key exists in the cache" do
      @doc.cacher.store('something', 'from cacher')
      @doc.variables.should_not_receive(:[])
      render
    end
    
    it "stores the value in the cache if a match is found and no key is pre-existing" do
      @doc.cacher.should_receive(:store).with('something','<span>from variables</span>')
      render
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