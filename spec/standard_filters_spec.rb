require File.dirname(__FILE__) + '/spec_helper.rb'

describe Hpreserve::StandardFilters do

  describe "upcase" do
    before { @f = Hpreserve::Filters.create }
    
    it "capitalizes the text of the node" do
      @doc = Hpricot("<span>foo</span>")
      @f.capitalize(@doc.at('span'))
      @doc.at('span').inner_text.should == 'Foo'
    end
    
  end
  
  describe "date" do
    before { @f = Hpreserve::Filters.create }
    
    it "handles strftime arguments" do
      @doc = Hpricot("<span>Wed, 26 Mar 2008 23:45:55 -0700</span>")
      @f.date(@doc.at('span'), '%e %b %y')
      @doc.at('span').inner_html.should == '26 Mar 08'
    end
  end
  
  
  describe "remove" do
    before { @f = Hpreserve::Filters.create }
    
    it "removes the node from the document" do
      @doc = Hpricot("<div>blah <div>Attention Client: This will be cooler</div><div>blah</div></div>")
      @f.remove(@doc.at('div div'))
      @doc.to_plain_text.should == "blah blah"
    end
  end
  
  describe "unwrap" do
    before { @f = Hpreserve::Filters.create }
    
    it "replaces the node with its content" do
      @doc = Hpricot("<div>Value</div>")
      @f.unwrap(@doc.at('div'))
      @doc.to_s.should == 'Value'
    end
  end
  
  describe "link" do
    before { @f = Hpreserve::Filters.create }
    
    it "sets the href attribute to the url value" do
      @doc = Hpricot("<a href=''>Foo</a>")
      @f.link(@doc.at('a'), 'foo.com')
      @doc.at('a')['href'].should == 'foo.com'
    end
  end
  
  describe "add_class" do
    before { @f = Hpreserve::Filters.create }
    
    it "appends the class to the element's classes" do
      @doc = Hpricot("<span class='foo'>Foo</span>")
      @f.add_class(@doc.at('span'), 'bar')
      @doc.at('span').classes.should == ['foo', 'bar']
    end
  end
  
  describe "set_class" do
    before { @f = Hpreserve::Filters.create }
    
    it "replacess the element's classes" do
      @doc = Hpricot("<span class='foo'>Foo</span>")
      @f.set_class(@doc.at('span'), 'bar')
      @doc.at('span').classes.should == ['bar']
    end
    
  end

end