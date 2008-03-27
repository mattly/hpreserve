begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

require 'rubygems'
gem 'ruby-debug'
require 'ruby-debug'

require "hpricot"
require "#{File.dirname(__FILE__)}/../lib/hpreserve"

Debugger.start