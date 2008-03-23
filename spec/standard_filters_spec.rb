require File.dirname(__FILE__) + '/spec_helper.rb'

describe Hpreserve::StandardFilters do

  describe "upcase" do
    before { @f = Hpreserve::Filters.create }
    
    it "upcases the text of the node" do
      @doc = Hpricot("<span>foo</span>")
      @f.upcase(@doc.at('span')).inner_text.should == 'FOO'
    end
    
  end

end