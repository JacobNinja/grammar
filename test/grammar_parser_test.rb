require File.expand_path('../test_helper', __FILE__)

class GrammarParserTest < Test::Unit::TestCase

  attr_reader :foo
  def setup
    @foo = Grammar::Token.new('foo', 1, 0)
  end

  test 'variable' do
    assert_equal Grammar::Var.new(foo), Grammar::Parser.parse('foo')
  end

  test 'function' do
    assert_equal Grammar::Function.new(foo), Grammar::Parser.parse('foo()')
  end

  test 'nested var' do
    assert_equal Grammar::NestedVar.new(foo, Grammar::Token.new('bar', 1, 4)), Grammar::Parser.parse('foo.bar')
  end

  test 'function with 1 argument' do
    arg = Grammar::Var.new(Grammar::Token.new('bar', 1, 4))
    assert_equal Grammar::Function.new(foo, [arg]), Grammar::Parser.parse('foo(bar)')
  end

  test '4 nested var' do
    assert_equal Grammar::NestedVar.new(foo, Grammar::Token.new('bar', 1, 4), Grammar::Token.new('baz', 2, 5), Grammar::Token.new('fizz', 2, 9)),
                 Grammar::Parser.parse(<<-RUBY)
foo.bar
    .baz.fizz
    RUBY
  end

end