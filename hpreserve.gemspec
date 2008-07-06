require 'rake'
Gem::Specification.new do |s|
  s.name          = "hpreserve"
  s.version       = "0.2.1"
  s.date          = "2008-07-05"

  s.summary       = "A humane, eval-safe HTML templating system expressed in HTML."

  s.author        = "Matthew Lyon"
  s.email         = "matt@flowerpowered.com"
  s.homepage      = "http://github.com/mattly/hpreserve"
  
  s.add_dependency 'hpricot', ['>= 0.6.0']
  
  s.has_rdoc      = false
  
  s.files         = FileList["Manifest.txt", "Rakefile", "README.mkdn", "lib/**/*.rb", "spec/*.rb"].to_a

  s.require_path  = 'lib'

end