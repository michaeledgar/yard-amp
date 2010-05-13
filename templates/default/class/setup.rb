def init
  super
  sections.place(:amp_options).before(:constant_summary)
end

def amp_options
  unless object[:amp_data] && object[:amp_data][:options]
    @amp_options = [] 
  else
    @amp_options = object[:amp_data][:options].sort do |x, y|
      x.name <=> y.name
    end
  end
  erb(:amp_options)
end