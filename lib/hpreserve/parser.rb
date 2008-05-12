module Hpreserve
  class Parser
  
    def self.render(doc='', variables={})
      doc = new(doc)
      doc.render(variables)
    end
    
    attr_accessor :doc, :variables, :filter_sandbox, :include_base
  
    def initialize(doc='')
      self.doc = Hpricot(doc)
      self.filter_sandbox = Hpreserve::Filters.create
    end
  
    def variables=(vars)
      @variables = Hpreserve::Variables.new(vars)
    end
  
    def render(vars=nil)
      self.variables = vars unless vars.nil?
      render_nodes
      doc.to_s
    end
    
    def render_includes
      (doc/"[@include]").each do |node|
        var, default = node['include'].split('|').collect {|s| s.strip }
        incl = variables.substitute(var)
        incl = [include_base, incl.split('.')].flatten.compact
        node.inner_html = variables[incl] || variables[default]
        node.remove_attribute('include')
      end
    end
    
    def render_nodes(base=doc)
      (base/'meta[@content]').each {|node| node.set_attribute('content', variables.substitute(node['content']))}
      (base/'[@content]:not(meta)').each {|node| render_node_content(node) }
      (base/'[@filter]').each {|node| render_node_filters(node) }
    end
    
    def render_node_content(node)
      value = variables[node.remove_attribute('content').strip.split('.')]
      value = value['default'] if value.respond_to?(:has_key?)
      render_collection(node, value) and return if value.is_a?(Array)
      node.inner_html = value
    end
    
    def render_node_filters(node)
      filters = Hpreserve::Filters.parse(node.remove_attribute('filter'))
      filters.each do |filterset|
        filter = filterset.shift
        next unless filter_sandbox.respond_to?(filter)
        args = filterset.collect {|a| variables.substitute(a) }
        filter_sandbox.run(filter, node, *args)
      end
    end
    
    def render_collection(node, values=[])
      variable_name = node.remove_attribute('local') || 'item'
      base = node.children.detect {|n| !n.is_a?(Hpricot::Text) }
      base.following.remove
      base.preceding.remove
      template = Marshal.dump(base)
      values.each_with_index do |value, index|
        variables.storage[variable_name] = value
        ele = Marshal.load(template)
        node.insert_after(ele, node.children.last)
        render_nodes(ele)
      end
      base.swap('')
    end
  end
end