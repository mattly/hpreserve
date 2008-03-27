require File.dirname(__FILE__) + '/spec_helper.rb'

describe Hpreserve::StandardFilters do

  describe "upcase" do
    before { @f = Hpreserve::Filters.create }
    
    it "capitalizes the text of the node" do
      @doc = Hpricot("<span>foo</span>")
      @f.capitalize(@doc.at('span')).inner_text.should == 'Foo'
    end
    
  end
  
  describe "remove" do
    before { @f = Hpreserve::Filters.create }
    
    it "removes the node from the document" do
      @doc = Hpricot("<div>Attention Client: This will be cooler</div><div>blah</div>")
      @f.remove(@doc.at('div'))
      @doc.to_plain_text.should == "blah"
    end
  end
  
  describe "unwrap" do
    before { @f = Hpreserve::Filters.create }
    
    it "replaces the node with its content" do
      @doc = Hpricot("<div>Value</div>")
      @f.unwrap(@doc.at('div')).should == 'Value'
    end
  end

end