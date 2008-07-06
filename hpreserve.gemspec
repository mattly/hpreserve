Gem::Specification.new do |s|
  s.name = %q{hpreserve}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Lyon"]
  s.date = %q{2008-07-06}
  s.description = %q{A humane, eval-safe HTML templating system expressed in HTML.}
  s.email = %q{matt@flowerpowered.com}
  s.files = ["README.mkdn", "Rakefile", "spec/abstract_cacher_spec.rb", "spec/file_cacher_spec.rb", "spec/filters_spec.rb", "spec/parser_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/standard_filters_spec.rb", "spec/variables_spec.rb", "lib/hpreserve", "lib/hpreserve/abstract_cacher.rb", "lib/hpreserve/extensions.rb", "lib/hpreserve/file_cacher.rb", "lib/hpreserve/filters.rb", "lib/hpreserve/parser.rb", "lib/hpreserve/standard_filters.rb", "lib/hpreserve/variables.rb", "lib/hpreserve.rb"]
  s.homepage = %q{http://github.com/mattly/hpreserve}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A humane, eval-safe HTML templating system expressed in HTML.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<hpricot>, [">= 0.6.0"])
      s.add_runtime_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<hpricot>, [">= 0.6.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0.6.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
