module Hpreserve
  class Parser
  
    def self.render(doc='', variables={})
      doc = new(doc)
      doc.render(variables)
    end
    
    attr_accessor :doc, :variables, :filter_sandbox, :include_base, :cacher
  
    def initialize(doc='')
      self.doc = Hpricot(doc)
      self.filter_sandbox = Hpreserve::Filters.create
    end
  
    def variables=(vars)
      @variables = Hpreserve::Variables.new(vars)
    end
  
    def render(vars=nil)
      self.variables = vars unless vars.nil?
      render_includes
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
      variable = node.remove_attribute('content').strip
      cache = cacher.nil? ? nil : cacher.match?(variable)
      if cache and stored = cacher.retrieve(cache)
        node.swap(stored)
      else
        value = variables[variable.split('.')]
        value = value['default'] if value.respond_to?(:has_key?)
        if value.is_a?(Array)
          render_collection(node, value)
        else
          node.inner_html = value
        end
        render_node_filters(node) if node['filter']
        cacher.store(cache, node.to_s) if cache
      end
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
      template = base.to_s
      values.each_with_index do |value, index|
        variables.storage[variable_name] = value
        ele = (Hpricot(template)/'*').first
        node.insert_after(ele, node.children.last)
        render_nodes(ele)
      end
      base.swap('')
    end
  end
end