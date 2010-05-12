module YARD::Amp
  ##
  # This handler is used by the Ruby 1.9+ parser engine. Uses AST nodes.
  #
  # All the interesting logic is actually all in SharedMethods. This class
  # specifically defines the parsing logic to get the data ready for the
  # Shared Methods.
  class ModernCommandHandler < YARD::Handlers::Ruby::Base
    handles method_call(:command)
    include YARD::CodeObjects
    
    def process
      if statement.parameters.size != 2
        raise YARD::Parser::UndocumentableError, 'command declaration with invalid parameters'
      end
      command_name = statement.parameters.first.source
      command_name = command_name[1..-1] if command_name[0,1] == ":"
      
      klass = register ClassObject.new(commands_module, command_name.capitalize) do |o|
        o.superclass = P("Amp::Command")
        o.superclass.type = :class if o.superclass.is_a?(Proxy)
      end
      p klass
    end
    
    def commands_module
      mod = register ModuleObject.new(:root, "Amp")
      com_mod = register ModuleObject.new(mod, "Commands")
    end
  end
end