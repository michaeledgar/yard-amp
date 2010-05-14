module YARD::Amp
  class OptionObject < YARD::CodeObjects::Base
    attr_accessor :description, :options
    def initialize(namespace, name, description, opts = {}, *args)
      super
      self.description, self.options = description, opts
      opts["type"] ||= "flag"
    end
    
    def signature
      "--#{self.name}" +
        (options["short"] && options["short"] != "none" ? ", -#{options["short"]}" : "") +
        case options["type"]
        when "flag"; ""
        when "int"; " &lt;i&gt;"
        when "ints"; " &lt;i+&gt;"
        when "string"; " &lt;s&gt;"
        when "strings"; " &lt;s+&gt;"
        when "float"; " &lt;f&gt;"
        when "floats"; " &lt;f+&gt;"
        when "io"; " &lt;filename/uri&gt;"
        when "ios"; " &lt;filename/uri+&gt;"
        end.to_s
    end
  end
end