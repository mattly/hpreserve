require "rake/gempackagetask"
Dir['tasks/**/*.rake'].each { |rake| load rake }

spec = Gem::Specification.new do |s|
  s.name         = 'hpreserve'
  s.version      = '0.2.1'
  s.platform     = Gem::Platform::RUBY
  s.author       = "Matthew Lyon"
  s.email        = "matt@flowerpowered.com.com"
  s.homepage     = "http://github.com/mattly/hpreserve"
  s.summary      = "A humane, eval-safe HTML templating system expressed in HTML."
  # s.bindir       = "bin"
  s.description  = s.summary
  # s.executables  = %w( merb )
  s.require_path = "lib"
  s.files        = %w( README.mkdn Rakefile ) + Dir["{spec,lib}/**/*"]
 
  # rdoc
  s.has_rdoc         = false
  # s.extra_rdoc_files = %w( README LICENSE TODO )
  #s.rdoc_options     += RDOC_OPTS + ["--exclude", "^(app|uploads)"]
 
  # Dependencies
  s.add_dependency "hpricot"
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end
 
namespace :github do
  desc "Update Github Gemspec"
  task :update_gemspec do
    skip_fields = %w(new_platform original_platform)
    integer_fields = %w(specification_version)
 
    result = "Gem::Specification.new do |s|\n"
    spec.instance_variables.each do |ivar|
      value = spec.instance_variable_get(ivar)
      name  = ivar.split("@").last
      next if skip_fields.include?(name) || value.nil? || value == "" || (value.respond_to?(:empty?) && value.empty?)
      if name == "dependencies"
        value.each do |d|
          dep, *ver = d.to_s.split(" ")
          result <<  "  s.add_dependency #{dep.inspect}, #{ver.join(" ").inspect.gsub(/[()]/, "")}\n"
        end
      else
        case value
        when Array
          value =  name != "files" ? value.inspect : value.inspect.split(",").join(",\n")
        when String
          value = value.to_i if integer_fields.include?(name)
          value = value.inspect
        else
          value = value.to_s.inspect
        end
        result << "  s.#{name} = #{value}\n"
      end
    end
    result << "end"
    File.open(File.join(File.dirname(__FILE__), "#{spec.name}.gemspec"), "w"){|f| f << result}
  end
end