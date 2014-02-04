require File.expand_path('../test_helper', __FILE__)

class GrammarResolverTest < GrammarTest

  def assert_result(expected, result)
    assert_equal expected, result.value
  end

  test 'missing data' do
    sut = Grammar::Var.new(foo)
    env = {}
    assert_result nil, sut.resolve(env)
  end

  test 'variable' do
    sut = Grammar::Var.new(foo)
    env = {
        'foo' => 'bar'
    }
    assert_result 'bar', sut.resolve(env)
  end

  test 'nested variable' do
    sut = Grammar::NestedVar.new(foo, bar)
    env = {
        'foo' => {
            'bar' => 'baz'
        }
    }
    assert_result 'baz', sut.resolve(env)
  end

  test 'function' do
    sut = Grammar::Function.new(foo)
    env = {
        'functions' => {
          'foo' => -> { 3 }
        }
    }
    assert_result 3, sut.resolve(env)
  end

  test 'function with variable arg' do
    sut = Grammar::Function.new(foo, [Grammar::Var.new(bar)])
    env = {
        'functions' => { 'foo' => -> (a) { a * 10 } },
        'bar' => 3
    }
    assert_result 30, sut.resolve(env)
  end

  test 'nested function with args' do
    sut = Grammar::Function.new(foo, [Grammar::Function.new(bar), Grammar::Var.new(baz)])
    env = {
        'functions' => {
          'foo' => -> (a, b) { a + b },
          'bar' => -> { 5 }
        },
        'baz' => 10
    }
    assert_result 15, sut.resolve(env)
  end

  test 'nested function with nested args' do
    nested_var = Grammar::NestedVar.new(Grammar::Token.new('greg'), Grammar::Token.new('bill'))
    baz = Grammar::Var.new(Grammar::Token.new('baz'))
    sut = Grammar::Function.new(foo, [Grammar::Function.new(bar, [nested_var, baz])])
    env = {
        'functions' => {
          'foo' => -> (a) { a - 1 },
          'bar' => -> (a, b) { a * b }
        },
        'baz' => 10,
        'greg' => {
            'bill' => 3
        }
    }
    assert_result 29, sut.resolve(env)
  end

  test 'four nested vars' do
    sut = Grammar::NestedVar.new(foo, bar, Grammar::Var.new(baz), Grammar::Var.new(Grammar::Token.new('fizz')))
    env = {
        'foo' => {
            'bar' => {
                'baz' => {
                    'fizz' => 10
                }
            }
        }
    }
    assert_result 10, sut.resolve(env)
  end

end
