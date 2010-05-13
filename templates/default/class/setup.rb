include T('default/class')

def init
  super
  sections.last.place(:amp_options).before(:constant_summary)
end

def option_listing
  return @amp_options if @amp_options
  return [] unless object.has_key?(:amp_data) && object[:amp_data].has_key?(:options)
  @amp_options = object[:amp_data][:options].sort do |x, y|
    x[:name] <=> y[:name]
  end
end