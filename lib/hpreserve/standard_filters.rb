module Hpreserve
  module StandardFilters
  
    def capitalize(node)
      node.inner_html = node.inner_text.capitalize
      node
    end
    
  end
end

Hpreserve::Filters.register(Hpreserve::StandardFilters)