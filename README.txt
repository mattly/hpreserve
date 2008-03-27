Hpreserve aims to be a humane, eval-safe templating system built upon the excellent
Hpricot DOM manipulation library. My primary goal for Hpreserve is to have a system
that doesn't require an interpreter to preview the design in a browser. Sample data
for the preview is simply "made up" by the designer and replaced by the template
system at runtime.

Rather than use a DOM-id based replacement approach a-la Lilu, I have chosen to go
with attaching other non-standard attributes to elements to direct the filter
system:
  
 * content: refers to the variable to replace the content of the element with 
 * include: like content but its contents will be further parsed for more content
 * filter: a list of filters to run on the content, for example truncation or
capitalization.

Planned but Unimplemented Features:

 * referring to a variable's content in a filter directive
 * iterating over collections
 * automatic escaping of html entities, and the ability to override that
