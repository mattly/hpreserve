require "rake"
require "rake/gempackagetask"
Dir['tasks/**/*.rake'].each { |rake| load rake }

desc "Run the specs."
task :default => :spec

spec = Gem::Specification.new do |s|
  s.name         = 'hpreserve'
  s.version      = '0.2.1'
  s.summary      = "A humane, eval-safe HTML templating system expressed in HTML."
  s.description  = s.summary

  s.author       = "Matthew Lyon"
  s.email        = "matt@flowerpowered.com"
  s.homepage     = "http://github.com/mattly/hpreserve"

  s.require_path = "lib"
  s.files        = %w( README.mkdn Rakefile ) + Dir["{spec,lib}/**/*"]
 
  # rdoc
  s.has_rdoc         = false
  # s.extra_rdoc_files = %w( README LICENSE TODO )
  #s.rdoc_options     += RDOC_OPTS + ["--exclude", "^(app|uploads)"]
 
  # Dependencies
  s.add_dependency "hpricot", ">= 0.6.0"
  s.add_dependency "rspec"
  
  # Requirements
  s.required_ruby_version = ">= 1.8.6"
end

desc "create .gemspec file (useful for github)"
task :gemspec do
  filename = "#{spec.name}.gemspec"
  File.open(filename, "w") do |f|
    f.puts spec.to_ruby
  end
end