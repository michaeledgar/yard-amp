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

      parse_block statement[2].children[1], owner: klass
    end
    
    def commands_module
      mod = register ModuleObject.new(:root, "Amp")
      com_mod = register ModuleObject.new(mod, "Commands")
    end
  end
  
  class ModernAmpCommandHandler < YARD::Handlers::Ruby::Base
    include ParsingHelpers
    def process
      return nil unless owner.inheritance_tree(false).include?(P("Amp::Command"))
      owner[:amp_data] ||= {}
      true
    end
    
    def attach_metadata(meta = {})
      owner[:amp_data].merge!(meta)
    end
    
  end
  
  class ModernHelpHandler < ModernAmpCommandHandler
    handles method_call(:help), method_call(:help=)
    
    def process
      return unless super
      params = statement.parameters
      attach_metadata(help: params.first.source)
    end
  end
  
  class ModernDescriptionHandler < ModernAmpCommandHandler
    handles method_call(:desc), method_call(:desc=)
    
    def process
      return unless super
      params = statement.parameters
      attach_metadata.merge!(desc: params.first.source)
    end
  end
  
  class ModernOptionHandler < ModernAmpCommandHandler
    handles method_call(:opt), method_call(:add_opt)
    
    def process
      return unless super
      params = statement.parameters
      option = parse_parameters(params)
      owner[:amp_data][:options] ||= []
      owner[:amp_data][:options] << option
    end
    
    def parse_parameters(params)
      option = {}
      option[:name] = clean_string(params.first.source)
      option[:description] = clean_string(params[1].source)
      if params[2]
        option[:options] = parse_hash(params[2])
      end
      option
    end
  end
end