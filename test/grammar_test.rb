require 'test/unit'
require File.expand_path('../../lib/grammar', __FILE__)

class GrammarParserTest < Test::Unit::TestCase

  test 'variable' do
    assert_equal Grammar::Var.new(Grammar::Token.new('foo', 1, 0)), Grammar::Parser.parse('foo')
  end

  test 'function' do
    assert_equal Grammar::Function.new(Grammar::Token.new('foo', 1, 0)), Grammar::Parser.parse('foo()')
  end

  test 'nested var' do
    assert_equal Grammar::NestedVar.new(Grammar::Token.new('foo', 1, 0), Grammar::Token.new('bar', 1, 4)), Grammar::Parser.parse('foo.bar')
  end

  test 'function with 1 argument' do
    arg = Grammar::Var.new(Grammar::Token.new('bar', 1, 4))
    assert_equal Grammar::Function.new(Grammar::Token.new('foo', 1, 0), [arg]), Grammar::Parser.parse('foo(bar)')
  end

end