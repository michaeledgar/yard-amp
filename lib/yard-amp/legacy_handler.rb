module YARD::Amp
  ##
  # This handler is used by the Ruby 1.9+ parser engine. Uses AST nodes.
  #
  # All the interesting logic is actually all in SharedMethods. This class
  # specifically defines the parsing logic to get the data ready for the
  # Shared Methods.
  class LegacyCommandHandler < YARD::Handlers::Ruby::Legacy::Base
    MATCH = /command\(?\s*(.*?)\s*\)?\s*(do|\{)/
    handles MATCH
    #include YARD::CodeObjects
    include ParsingHelpers
    
    def process
      params = statement.tokens.to_s[MATCH, 1].split(",").map {|x| clean_string(x)}
      if params.size != 1
        raise YARD::Parser::UndocumentableError, 'command declaration with invalid parameters'
      end
      
      command_name = params.first
      command_name = command_name[1..-1] if command_name[0,1] == ":"
      # 
      klass = ClassObject.new(commands_module, command_name.capitalize) do |o|
        o.superclass = P("Amp::Command")
        o.superclass.type = :class if o.superclass.is_a?(Proxy)
      end
      klass[:amp_data] ||= {}
      klass[:amp_data].merge!(:docstring => statement.comments)
      # 
      parse_block(:owner => klass)
      register klass
      construct_docstring(klass)
    end
    
    def commands_module
      mod = register ModuleObject.new(:root, "Amp")
      com_mod = register ModuleObject.new(mod, "Commands")
    end
  end
  # 
  class LegacyAmpCommandHandler < YARD::Handlers::Ruby::Legacy::Base
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
  # 
  class LegacyHelpHandler < LegacyAmpCommandHandler
    MATCH = /help=?\(?\s*(.*)\s*\)?\s*/
    handles MATCH
    
    def process
      return unless super
      param = clean_string(statement.tokens.to_s[MATCH, 1].strip)
      attach_metadata(:help => param)
    end
  end
  # 
  class LegacyDescriptionHandler < LegacyAmpCommandHandler
    MATCH = /desc=?\(?\s*(.*)\s*\)?\s*/
    handles MATCH
    
    def process
      return unless super

      param = clean_string(statement.tokens.to_s[MATCH, 1].strip)
      attach_metadata.merge!(:desc => param)
    end
  end
  # 
  class LegacyWorkflowHandler < LegacyAmpCommandHandler
    MATCH = /workflow=?\(?\s*(.*)\s*\)?\s*/
    handles MATCH
    
    def process
      return unless super
      param = clean_string(statement.tokens.to_s[MATCH, 1].strip)
      attach_metadata.merge!(:workflow => param)
    end
  end
  # 
  class LegacyOptionHandler < LegacyAmpCommandHandler
    MATCH = /(opt|add_opt)\(?\s*(.*)\s*\)?\s*/
    handles MATCH
    
    def process
      return unless super
      params = split_by_comma_smart(statement.tokens.to_s[MATCH, 2]).map {|x| clean_string(x.strip)}
      option = parse_parameters(params)
      owner[:amp_data][:options] ||= []
      owner[:amp_data][:options] << option
    end
    
    def parse_parameters(params)
      name = clean_string(params.first)
      description = clean_string(params[1])
      option = OptionObject.new(owner, name, description)
      if params[2..-1]
        reg = /(.*?)\s*=>\s*([^,]*)/
        params[2..-1].each do |param|
          if param =~ reg
            option.options[clean_string($1)] = clean_string $2
          end
        end
      end
      option
    end
  end
end