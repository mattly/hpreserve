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
      self.include_base = 'includes'
    end
  
    def variables=(vars)
      @variables = Hpreserve::Variables.new(vars)
    end
  
    def render(variables={})
      self.variables = variables
      render_content
      run_filters
      @doc.to_s
    end
    
    def render_includes
      (@doc/"[@include]").each do |node|
        node.inner_html = variables[[include_base, node['include'].split('.')].flatten]
        node.remove_attribute('include')
      end
    end
    
    def render_content
      (@doc/"[@content]").each do |node|
        value = variables[node['content'].split('.')]
        value = value['default'] if value.respond_to?(:has_key?)
        node.inner_html = value
        node.remove_attribute('content')
      end
    end
  
    def run_filters
      (@doc/"[@filter]").each do |node|
        filters = Hpreserve::Filters.parse(node['filter'])
        filters.each do |filterset|
          filter = filterset.shift
          next unless filter_sandbox.respond_to?(filter)
          args = [node, filterset].flatten
          filter_sandbox.__send__(filter, *args)
        end
        node.remove_attribute('filter')
      end
    end
    
  end
end