require 'test/unit'
require File.expand_path('../../lib/grammar', __FILE__)

class GrammarParserTest < Test::Unit::TestCase

  test 'variable' do
    assert_equal Grammar::Var.new(Grammar::Token.new('foo', 1, 0)), Grammar::Parser.parse('foo')
  end

  test 'function' do
    assert_equal Grammar::Function.new(Grammar::Token.new('foo', 1, 0)), Grammar::Parser.parse('foo()')
  end

end