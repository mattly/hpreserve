class Hpreserve::Parser
  
  attr_accessor :doc, :variables
  
  def initialize(doc='')
    self.doc = Hpricot(doc)
  end
  
  def self.render(doc='', variables={})
    doc = new(doc)
    doc.render(variables)
  end
  
  # fun Hpricot tricks: http://code.whytheluckystiff.net/hpricot/wiki/HpricotCssSearch
  
  def variables=(vars)
    @variables = Hpreserve::Variables.new(vars)
  end
  
  def render(variables={})
    self.variables = variables
    render_content
    @doc.to_s
  end
  
  def render_content
    (@doc/"[@content]").each do |node|
      node.inner_html = variables[node['content'].split('.')]
      node.remove_attribute('content')
    end
  end
  
  def replace_wrappers
    (@doc/"wrapper").each {|e| e.after(e.inner_html) }.remove
  end
  
end