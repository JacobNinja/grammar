require File.expand_path('../test_helper', __FILE__)

class GrammarResolverTest < Test::Unit::TestCase

  attr_reader :foo, :bar
  def setup
    @foo = Grammar::Token.new('foo')
    @bar = Grammar::Token.new('bar')
  end

  test 'variable' do
    sut = Grammar::Var.new(foo)
    env = {
        'foo' => 'bar'
    }
    assert_equal 'bar', sut.resolve(env)
  end

  test 'nested variable' do
    sut = Grammar::NestedVar.new(foo, bar)
    env = {
        'foo' => {
            'bar' => 'baz'
        }
    }
    assert_equal 'baz', sut.resolve(env)
  end

  test 'function' do
    sut = Grammar::Function.new(foo)
    env = {
        'foo' => -> { 3 }
    }
    assert_equal 3, sut.resolve(env)
  end

  test 'function with variable arg' do
    sut = Grammar::Function.new(foo, [Grammar::Var.new(bar)])
    env = {
        'foo' => -> (a) { a * 10 },
        'bar' => 3
    }
    assert_equal 30, sut.resolve(env)
  end

  test 'nested function with args' do
    baz = Grammar::Var.new(Grammar::Token.new('baz'))
    sut = Grammar::Function.new(foo, [Grammar::Function.new(bar), baz])
    env = {
        'foo' => -> (a, b) { a + b },
        'bar' => -> { 5 },
        'baz' => 10
    }
    assert_equal 15, sut.resolve(env)
  end

  test 'nested function with nested args' do
    nested_var = Grammar::NestedVar.new(Grammar::Token.new('greg'), Grammar::Token.new('bill'))
    baz = Grammar::Var.new(Grammar::Token.new('baz'))
    sut = Grammar::Function.new(foo, [Grammar::Function.new(bar, [nested_var, baz])])
    env = {
        'foo' => -> (a) { a - 1 },
        'bar' => -> (a, b) { a * b },
        'baz' => 10,
        'greg' => {
            'bill' => 3
        }
    }
    assert_equal 29, sut.resolve(env)
  end

  test 'four nested vars' do
    sut = Grammar::NestedVar.new(foo, bar, Grammar::Var.new(Grammar::Token.new('baz')), Grammar::Var.new(Grammar::Token.new('fizz')))
    env = {
        'foo' => {
            'bar' => {
                'baz' => {
                    'fizz' => 10
                }
            }
        }
    }
    assert_equal 10, sut.resolve(env)
  end

end