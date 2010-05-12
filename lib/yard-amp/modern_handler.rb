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
      klass[:amp_data] ||= {}

      parse_block statement[2], owner: klass
    end
    
    def commands_module
      mod = register ModuleObject.new(:root, "Amp")
      com_mod = register ModuleObject.new(mod, "Commands")
    end
    
    def parse_block(inner_node, opts = {})
      push_state(opts) do
        nodes = case inner_node.type
                when :list then inner_node.children
                when :do_block then inner_node.children[1]
                else [inner_node]
                end
        parser.process(nodes)
      end
    end
  end
  
  class ModernHelpHandler < YARD::Handlers::Ruby::Base
    handles method_call(:help)
    include YARD::CodeObjects
    
    def process
      return unless owner.inheritance_tree(false).include?(P("Amp::Command"))
      params = statement.parameters
      owner[:amp_data].merge!(help: params.first.source)
    end
  end
  
  class ModernDescriptionHandler < YARD::Handlers::Ruby::Base
    handles method_call(:desc)
    include YARD::CodeObjects
    
    def process
      params = statement.parameters
      owner[:amp_data].merge!(desc: params.first.source)
    end
  end
end