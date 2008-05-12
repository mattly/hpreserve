require File.dirname(__FILE__) + '/spec_helper.rb'

describe Hpreserve::Filters do
  
  describe "sandbox" do
    before { @f = Hpreserve::Filters.create }
    # note: #should and #should_not are undefined at initialize and are not available
    
    it "extends with @@filter_modules" do
      @f.respond_to?('capitalize').should be_true
    end
    
    it "does not respond to or send non-allowed methods" do
      lambda { @f.__send__('instance_eval')}.should raise_error(NoMethodError)
    end
    
    it "executes filters via the 'run' method" do
      @doc = Hpricot('<span>foo</span>')
      @f.run('capitalize', @doc.at('span'))
      @doc.at('span').inner_html.should == 'Foo'
    end
    
    it "parses arguments for variables and interprets them" do
      @doc = Hpricot('<span>foo</span>')
      vars = mock('variables')
      vars.should_receive(:substitute).with('{thing.link}/bar').and_return('foo/bar')
      @f = Hpreserve::Filters.create( vars )
      @f.run('link', @doc.at('span'), '{thing.link}/bar')
      @doc.at('span')['href'].should == 'foo/bar'
    end
  end
  
  describe "filterstring parser" do
    it "handles single filters without arguments" do
      Hpreserve::Filters.parse('upcase').should == [['upcase']]
    end
    
    it "handles multiple filters without arguments" do
      Hpreserve::Filters.parse('upcase; downcase').should == [['upcase'], ['downcase']]
    end
    
    it "handles single filters with arguments" do
      Hpreserve::Filters.parse('truncate: 30, ...').should == [['truncate', '30', '...']]
    end
    
    it "handles complex filter directives" do
      Hpreserve::Filters.parse(
        'truncate: 30, ...; capitalize; link_to: @item.link; add_class: @item.type'
      ).should == [
        ['truncate', '30', '...'], ['capitalize'], ['link_to', '@item.link'], 
        ['add_class', '@item.type']
      ]
    end
    
  end
   
end