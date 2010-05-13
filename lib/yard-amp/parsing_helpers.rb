module YARD::Amp
  module ParsingHelpers
    def clean_string(str)
      if str[0,2] == ":\"" && str[-1,1] == "\""
        str[2..-2]
      elsif str[0,1] == ":"
        str[1..-1]
      elsif str[0,1] =~ /['"]/ && str[-1,1] == str[0,1]
        str[1..-2]
      else
        str
      end
    end
    
    def parse_hash(node)
      node.children.inject({}) do |hash, pair|
        unless pair.type == :assoc
          raise YARD::Parser::UndocumentableError, %Q{expected an :assoc in a hash but got #{pair.type}}
        end
        key = clean_string pair[0].source
        val = clean_string pair[1].source
        hash[key] = val
        hash
      end
    end
    
  end
end