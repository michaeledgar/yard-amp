require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ::YARD::Amp::ModernCommandHandler do
  include Helpers::Examples
  before(:all) do
    parse_file :simple_command
    @init_cmd = Registry.at("Amp::Commands::Init")
    @braced_cmd = Registry.at("Amp::Commands::Braced")
  end
  
  it "creates commands when parsing a command declaration" do
    @init_cmd.should_not be_nil
  end
  
  it "assigns commands the superclass of Amp::Command" do
    @init_cmd.superclass.path.should == "Amp::Command"
  end
  
  it "creates a metadata hash on amp command classes" do
    @init_cmd[:amp_data].should_not be_nil
  end
  
  it "extracts help information and attaches it as metadata" do
    @init_cmd[:amp_data].should have_key(:help)
    @init_cmd[:amp_data][:help].should == "Help info for init"
  end
  
  it "extracts description information and attaches it as metadata" do
    @init_cmd[:amp_data].should have_key(:desc)
    @init_cmd[:amp_data][:desc].should == "Initializes a new repository in the current directory."
  end
  
  it "retains the docstring attached to the call to #command" do
    @init_cmd.docstring.tags(:example).size.should == 2
  end
  
  it "ignores help or description calls not in a command" do
    Registry.at("NotACommand")[:amp_data].should be_nil
  end
  
  it "parses brace syntax as well as do...end syntax" do
    @braced_cmd.should_not be_nil
  end
  
  it "constructs a reasonable docstring" do
    @init_cmd.docstring.should == "== Initializes a new repository in the current directory.\n\nHelp info for init"
  end
  
  it "processes all the command-line options" do
    @init_cmd[:amp_data].should have_key(:options)
    @init_cmd[:amp_data][:options].size.should == 3
  end
  
  it "extracts the names of command-line options" do
    found_opts = @init_cmd[:amp_data][:options]
    ["type", "source", "no-opts"].each do |expected_opt|
      opt = found_opts.find {|x| x.name == expected_opt}
      fail "Option '#{expected_opt}' not found on the Init command." unless opt
    end
  end
  
  it "extracts the descriptions of command-line options" do
    found_opts = @init_cmd[:amp_data][:options]
    expected_descriptions = ["Which type of repository (git, hg)", "Where the source repository could be found"]
    expected_descriptions.each do |expected_desc|
      opt = found_opts.find {|x| x.description == expected_desc}
      fail "Option with description '#{expected_desc}' not found on the Init command." unless opt
    end
  end
  
  it "extracts the additional options associated with individual command-line options" do
    found_opts = @init_cmd[:amp_data][:options]
    type_opt = found_opts.find {|x| x.name == "type"}
    source_opt = found_opts.find {|x| x.name == "source"}
    none_opt = found_opts.find {|x| x.name == "no-opts"}

    type_opt.should_not be_nil
    source_opt.should_not be_nil
    type_opt[:options].should_not be_nil
    source_opt[:options].should_not be_nil

    type_opt[:options]["short"].should == "-t"
    type_opt[:options]["type"].should == "string"
    type_opt[:options]["default"].should == "hg"
    
    source_opt[:options]["short"].should == "-s"
    source_opt[:options]["multi"].should == "true"
    
    none_opt[:options].should be_empty
  end
end
