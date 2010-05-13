require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ::YARD::Amp::ParsingHelpers, '#clean_string' do
  include YARD::Amp::ParsingHelpers
  it "cleans normal symbols" do
    clean_string(":some_symbol").should == "some_symbol"
  end
  
  it "cleans quoted symbols" do
    clean_string(":\"long symbol\"").should == "long symbol"
  end
  
  it "cleans normal strings" do
    clean_string("\"a big long string\"").should == "a big long string"
  end
end

describe ::YARD::Amp::ParsingHelpers, '#parse_hash' do
  include YARD::Amp::ParsingHelpers
  it "parses hashes into hash objects" do
    ast = YARD::Parser::SourceParser.parse_string("{\"hello\" => \"world\"}").ast.first
    parse_hash(ast).should == {"hello" => "world"}
  end
  
  it "parses hashes with symbols into string-based hashes" do
    ast = YARD::Parser::SourceParser.parse_string("{:\"no-color\" => true}").ast.first
    parse_hash(ast).should == {"no-color" => "true"}
  end
end