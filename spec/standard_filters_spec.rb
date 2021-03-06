require File.dirname(__FILE__) + '/spec_helper.rb'

describe Hpreserve::StandardFilters do

  describe "upcase" do
    before { @f = Hpreserve::Filters.create }
    
    it "capitalizes the text of the node" do
      @doc = Hpricot("<span>foo</span>")
      @f.run 'capitalize', @doc.at('span')
      @doc.at('span').inner_text.should == 'Foo'
    end
    
  end
  
  describe "date" do
    before { @f = Hpreserve::Filters.create }
    
    it "handles strftime arguments" do
      @doc = Hpricot("<span>Wed, 26 Mar 2008 23:45:55 -0700</span>")
      @f.run 'date', @doc.at('span'), '%e %b %y'
      @doc.at('span').inner_html.should == '26 Mar 08'
    end
  end
  
  
  describe "remove" do
    before { @f = Hpreserve::Filters.create }
    
    it "removes the node from the document" do
      @doc = Hpricot("<div>blah <div>Attention Client: This will be cooler</div><div>blah</div></div>")
      @f.run 'remove', @doc.at('div div')
      @doc.to_plain_text.should == "blah blah"
    end
  end
  
  describe "unwrap" do
    before { @f = Hpreserve::Filters.create }
    
    it "replaces the node with its content" do
      @doc = Hpricot("<div>Value</div>")
      @f.run 'unwrap', @doc.at('div')
      @doc.to_s.should == 'Value'
    end
  end
  
  describe "link" do
    before { @f = Hpreserve::Filters.create }
    
    it "sets the href attribute to the url value" do
      @doc = Hpricot("<a href=''>Foo</a>")
      @f.run 'link', @doc.at('a'), 'foo.com'
      @doc.at('a')['href'].should == 'foo.com'
    end
  end
  
  describe "add_class" do
    before { @f = Hpreserve::Filters.create }
    
    it "appends the class to the element's classes" do
      @doc = Hpricot("<span class='foo'>Foo</span>")
      @f.run 'add_class', @doc.at('span'), 'bar'
      @doc.at('span').classes.should == ['foo', 'bar']
    end
  end
  
  describe "set_class" do
    before do
      @f = Hpreserve::Filters.create
      @doc = Hpricot("<span class='foo'>Foo</span>")
    end
    
    it "replacess the element's classes" do
      @f.run 'set_class', @doc.at('span'), 'bar'
      @doc.at('span').classes.should == ['bar']
    end
    
    it "santizes the class name" do
      @f.run 'set_class', @doc.at('span'), '.foo and bar'
      @doc.at('span').classes.should == ['foo-and-bar']
    end
    
    it "handles multiple class names with commas" do
      @f.run 'set_class', @doc.at('span'), 'foo', 'bar'
      @doc.at('span').classes.should == %w(foo bar)
    end
    
  end
  
  describe "set_id" do
    before { @f = Hpreserve::Filters.create }
    
    it "sets the element's id" do
      @doc = Hpricot("<span>foo</span>")
      @f.run 'set_id', @doc.at('span'), 'bar'
      @doc.at('span')['id'].should == 'bar'
    end
    
    it "replaces the element's id" do
      @doc = Hpricot("<span id='foo'>foo</span>")
      @f.run 'set_id', @doc.at('span'), 'bar'
      @doc.at('span')['id'].should == 'bar'
    end
  end

  
  describe "attr" do
    before { @f = Hpreserve::Filters.create }
    
    it "sets the attr for src" do
      @doc = Hpricot('<span>foo</span>')
      @f.run 'attr', @doc.at('span'), 'src', '/lolcat.jpg'
      @doc.at('span')['src'].should == '/lolcat.jpg'
    end
    
    it "clobbers the attr for src" do
      @doc = Hpricot('<img src="/loldog.jpg" />')
      @f.run 'attr', @doc.at('img'), 'src', '/lolcat.jpg'
      @doc.at('img')['src'].should == '/lolcat.jpg'
    end
  end
  
  describe "attr_on_child" do
    before { @f = Hpreserve::Filters.create }
    
    it "sets the attr on the named child element" do
      @doc = Hpricot('<div><span id="foo">foo</span><span id="bar">bar</span></div>')
      @f.run 'attr_on_child', @doc.at('div'), 'foo', 'class', 'active'
      @doc.at('#foo').classes.should == ['active']
    end
    
    it "handles a child not found" do
      html = '<div><span id="bar">bar</span></div>'
      @doc = Hpricot(html)
      @f.run 'attr_on_child', @doc.at('div'), 'foo', 'class', 'active'
      @doc.to_s.should == html
    end
  end
  
end