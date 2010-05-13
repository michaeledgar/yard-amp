module YARD::Amp
  class OptionObject < YARD::CodeObjects::Base
    attr_accessor :description, :options
    def initialize(namespace, name, description, opts = {}, *args)
      super
      self.description, self.options = description, opts
    end
  end
end