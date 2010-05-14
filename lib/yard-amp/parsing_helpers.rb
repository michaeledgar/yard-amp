module YARD::Amp
  module ParsingHelpers
    def clean_string(str)
      if str[0,2] == ":\"" && str[-1,1] == "\""
        str[2..-2]
      elsif str[0,1] == ":"
        str[1..-1]
      elsif str[0,1] =~ /['"]/ && str[-1,1] == str[0,1]
        str[1..-2]
      elsif str[0,3] =~ /%q\{/i && str[-1,1] == "}"
        str[3..-2]
      elsif str[0,3] == "<<-"
        prefix = str[3..-1] =~ /[\S]+/
        if prefix
          prefix = $&
          # check if it starts and ends with it
          if str[-1 * prefix.size..-1] == str[3...prefix.size+3]
            return str[3 + prefix.size..(-1 * prefix.size - 2)]
          end
        end
        str
      else
        str
      end
    end
    
    def construct_docstring(klass)
      klass.docstring = "== #{klass[:amp_data][:desc]}\n\n#{klass[:amp_data][:help]}\n#{klass[:amp_data][:docstring]}"
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
    
    def split_by_comma_smart(string)
      result = []
      in_quote = false
      last_spot = 0
      string.split(//).each_with_index do |char, idx|
        if char =~ /['"]/
          in_quote = !in_quote
        elsif char == "," && !in_quote
          result << string[last_spot..(idx - 1)]
          last_spot = idx + 1
        end
      end
      unless last_spot == string.size - 1
        result << string[last_spot..-1]
      end
      result
    end
    
  end
end