module YARD::Amp
  class Option < Struct.new(:name, :description, :options)
    def initialize(*args)
      super
      self.options ||= {}
    end
  end
end