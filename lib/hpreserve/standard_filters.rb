module Hpreserve
  module StandardFilters
  
    def capitalize(node)
      node.inner_html = node.inner_text.capitalize
      node
    end
    
    def date(node, strftime)
      time = Time.parse(node.inner_html)
      node.inner_html = time.strftime(strftime)
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
      attr(node, 'href', url)
      node
    end
    
    def add_class(node, *klasses)
      set_class(node, [node.classes, klasses].flatten)
      node
    end
    
    def set_class(node, *klasses)
      klasses = klasses.flatten.map! {|c| c.gsub(/[^\-\w]+/,'-').gsub(/^[^a-zA-Z]/,'') }
      attr(node, 'class', klasses.uniq.join(' '))
      node
    end
    
    def set_id(node, id)
      attr(node, 'id', id)
      node
    end
    
    def attr(node, attrib, value)
      node.set_attribute(attrib, value)
      node
    end
    
    def attr_on_child(node, child, attrib, value)
      node.at('#'+child).set_attribute(attrib, value)
      node
    end
    
  end
end

Hpreserve::Filters.register(Hpreserve::StandardFilters)