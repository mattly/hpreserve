module Hpreserve
  module StandardFilters
  
    def capitalize(node)
      node.inner_html = node.inner_text.capitalize
      node
    end
    
    
    # node modification filters
    
    def remove(node)
      node.parent.children.delete(node)
    end
    
    def unwrap(node)
      node.swap node.inner_html
    end
    
    def link(node, url)
      node['href'] = url
      node
    end
    
    def add_class(node, klass)
      node.set_attribute('class', node.classes.push(klass).uniq.join(' '))
      node
    end
    
    def set_class(node, klass)
      node.set_attribute('class', klass.split(' ').uniq.join(' '))
      node
    end
    
  end
end

Hpreserve::Filters.register(Hpreserve::StandardFilters)