require 'yard'
require File.join(File.dirname(__FILE__), 'yard-amp', 'option')
require File.join(File.dirname(__FILE__), 'yard-amp', 'parsing_helpers')
require File.join(File.dirname(__FILE__), 'yard-amp', 'modern_handler')  if RUBY_VERSION >= "1.9"
require File.join(File.dirname(__FILE__), 'yard-amp', 'legacy_handler')  unless RUBY_VERSION >= "1.9"

YARD::Templates::Engine.register_template_path File.join(File.dirname(__FILE__), '..', 'templates')