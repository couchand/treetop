dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The node returned by the nonterminal_symbol rule's successful parsing of an unquoted string" do
  include MetagrammarSpecContextHelper

  before(:all) do
    with_metagrammar(:nonterminal_symbol) do |parser|
      @node = parser.parse('foo')
    end
  end
  
  it "is successful" do
    @node.should be_success
  end

  it "has the Ruby source representation that evaluates to a nonterminal in the containing grammar" do    
    Bar = Grammar.new
    value = eval(@node.to_ruby(grammar_node_mock('Bar')))
    Bar.nonterminal_symbol(:foo).should == value
  end
end

describe "The subset of the Metagrammar rooted at the nonterminal_symbol rule" do
  include MetagrammarSpecContextHelper
  
  before do
    @root = :nonterminal_symbol
  end

  it "parses unquoted strings with underscores successfully" do
    with_metagrammar(@root) do |parser|
      parser.parse('underscore_rule_name').should be_success
    end
  end

  it "parses nonterminal names that begin with reserved words successfully" do
    with_metagrammar(@root) do |parser|
      parser.parse('rule_name').should be_success
      parser.parse('end_of_the_world').should be_success      
    end
  end
  
  it "does not parse 'rule' or 'end' as nonterminals" do
    with_metagrammar(@root) do |parser|    
      parser.parse('rule').should be_a_failure
      parser.parse('end').should be_a_failure
    end
  end
end