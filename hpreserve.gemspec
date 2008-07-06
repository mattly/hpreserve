Gem::Specification.new do |s|
  s.date = "Sun Jul 06 00:00:00 -0700 2008"
  s.authors = ["Matthew Lyon"]
  s.required_rubygems_version = ">= 0"
  s.version = "0.2.1"
  s.files = ["README.mkdn",
 "Rakefile",
 "spec/abstract_cacher_spec.rb",
 "spec/file_cacher_spec.rb",
 "spec/filters_spec.rb",
 "spec/parser_spec.rb",
 "spec/spec.opts",
 "spec/spec_helper.rb",
 "spec/standard_filters_spec.rb",
 "spec/variables_spec.rb",
 "lib/hpreserve",
 "lib/hpreserve/abstract_cacher.rb",
 "lib/hpreserve/extensions.rb",
 "lib/hpreserve/file_cacher.rb",
 "lib/hpreserve/filters.rb",
 "lib/hpreserve/parser.rb",
 "lib/hpreserve/standard_filters.rb",
 "lib/hpreserve/variables.rb",
 "lib/hpreserve.rb"]
  s.has_rdoc = "false"
  s.specification_version = "2"
  s.loaded = "false"
  s.email = "matt@flowerpowered.com.com"
  s.name = "hpreserve"
  s.required_ruby_version = ">= 0"
  s.bindir = "bin"
  s.rubygems_version = "1.2.0"
  s.homepage = "http://github.com/mattly/hpreserve"
  s.platform = "ruby"
  s.summary = "A humane, eval-safe HTML templating system expressed in HTML."
  s.description = "A humane, eval-safe HTML templating system expressed in HTML."
  s.add_dependency "hpricot", ">= 0, runtime"
  s.require_paths = ["lib"]
end