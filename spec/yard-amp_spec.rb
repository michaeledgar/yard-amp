require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ::YARD::Amp::ModernCommandHandler do
  include Helpers::Examples
  before(:all) do
    parse_file :simple_command
  end
  
  it "creates commands when parsing a command declaration" do
    Registry.at("Amp::Commands::Init").should_not be_nil
  end
  
  it "assigns commands the superclass of Amp::Command" do
    Registry.at("Amp::Commands::Init").superclass.path.should == "Amp::Command"
  end
end
