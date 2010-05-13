require 'yard'
require 'yard-amp/parsing_helpers'
require 'yard-amp/modern_handler'

YARD::Templates::Engine.register_template_path File.join(File.dirname(__FILE__), '..', 'templates')