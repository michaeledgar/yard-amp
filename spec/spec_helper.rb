$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'yard-amp'
require 'spec'
require 'spec/autorun'
require 'examples/example_helper'

Spec::Runner.configure do |config|
  
end
include YARD