module Hpreserve
  module StandardFilters
  
    def upcase(node)
      node.inner_html = node.inner_text.upcase
      node
    end
    
    def downcase(node)
      node.inner_html = node.inner_text.downcase
      node
    end
    
    def formatdate(node, *args)
      
    end
  
  end
end

Hpreserve::Filters.register(Hpreserve::StandardFilters)