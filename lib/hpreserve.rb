$:.unshift File.dirname(__FILE__)

module Hpreserve
  
end

require 'hpreserve/parser'
require 'hpreserve/extensions'
require 'hpreserve/abstract_cacher'
require 'hpreserve/file_cacher'
require 'hpreserve/variables'
require 'hpreserve/filters'
require 'hpreserve/standard_filters'