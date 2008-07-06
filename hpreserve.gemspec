Gem::Specification.new do |s|
  s.name          = "hpreserve"
  s.version       = "0.2.1"
  s.date          = "2008-07-05"

  s.description   = "A humane, eval-safe HTML templating system expressed in HTML."

  s.author        = "Matthew Lyon"
  s.email         = "matt@flowerpowered.com"
  s.homepage      = "http://github.com/mattly/hpreserve"
  
  s.add_dependency 'hpricot', ['>= 0.6.0']
  
  s.has_rdoc      = false
  
  s.files         = ["Manifest.txt", "Rakefile", "README.mkdn", "lib/**/*.rb", "spec/*.rb"]

  s.require_path  = 'lib'

end