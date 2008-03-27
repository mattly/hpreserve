module Hpreserve
  module StandardFilters
  
    def capitalize(node)
      node.inner_html = node.inner_text.capitalize
      node
    end
    
    
    
    def remove(node)
      node.parent.children.delete(node)
    end
    
    def unwrap(node)
      node.inner_html
    end
    
  end
end

Hpreserve::Filters.register(Hpreserve::StandardFilters)