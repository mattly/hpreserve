Hpreserve aims to be a humane, eval-safe templating system built upon the excellent
Hpricot DOM manipulation library. My primary goal for Hpreserve is to have a system
that doesn't require an interpreter to preview the design in a browser. Sample data
for the preview is simply "made up" by the designer and replaced by the template
system at runtime.

Rather than use a DOM-id based replacement approach a-la Lilu, I have chosen to go
with attaching other non-standard attributes to elements to direct the filter
system:

 * content: refers to the variable to replace the content of the element with 
 * filter: a list of filters to run on the content, for example truncation or
capitalization.

Additionally any content in <wrapper> tags is replaced by the template runtime with
their content. This allows content or filters to be run over text that doesn't
necessary belong in even a <span> tag.

Planned but Unimplemented Features:

 * referring to a variable's content in a filter directive
 * iterating over collections
 * more than a single filter :)
 * automatic escaping of html entities, and the ability to override that
