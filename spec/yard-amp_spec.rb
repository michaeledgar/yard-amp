require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ::YARD::Amp::ModernCommandHandler do
  include Helpers::Examples
  before(:all) do
    parse_file :simple_command
    @init_cmd = Registry.at("Amp::Commands::Init")
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
    @init_cmd[:amp_data][:help].should == "%Q{Help info for init}"
  end
  
  it "extracts description information and attaches it as metadata" do
    @init_cmd[:amp_data].should have_key(:desc)
    @init_cmd[:amp_data][:desc].should == %Q{"Initializes a new repository in the current directory."}
  end
  
end
