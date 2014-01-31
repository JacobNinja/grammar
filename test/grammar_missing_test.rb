require File.expand_path('../test_helper', __FILE__)

class GrammarMissingTest < GrammarTest

  def assert_missing(expected, result)
    assert_nil result.value
    assert_include result.missing.vars, expected
  end

  def assert_missing_function(expected, result)
    assert_nil result.value
    assert_include result.missing.functions, expected
  end

  test 'variable' do
    sut = Grammar::Var.new(foo)
    assert_missing ['foo'], sut.resolve({})
  end

  test 'nested variable missing root' do
    sut = Grammar::NestedVar.new(foo, bar)
    assert_missing ['foo'], sut.resolve({})
  end

  test 'nested variable missing child' do
    sut = Grammar::NestedVar.new(foo, bar, Grammar::Token.new('baz'))
    env = {
        'foo' => {
            'bar' => {}
        }
    }
    assert_missing ['foo', 'bar', 'baz'], sut.resolve(env)
  end

  test 'function' do
    sut = Grammar::Function.new(foo)
    assert_missing_function 'foo', sut.resolve({})
  end

  test 'function with var' do
    sut = Grammar::Function.new(foo, [Grammar::Var.new(bar)])
    env = {
        'foo' => -> (*) {}
    }
    assert_missing ['bar'], sut.resolve(env)
  end

  test 'function and var' do
    sut = Grammar::Function.new(foo, [Grammar::Var.new(bar)])
    assert_missing ['bar'], sut.resolve({})
    assert_missing_function 'foo', sut.resolve({})
  end

  test 'function with multiple vars' do
    sut = Grammar::Function.new(foo, [Grammar::Var.new(bar), Grammar::Var.new(baz)])
    env = {
        'foo' => -> (*) {}
    }
    assert_missing ['bar'], sut.resolve(env)
    assert_missing ['baz'], sut.resolve(env)
  end

  test 'function with nested var' do
    sut = Grammar::Function.new(foo, [Grammar::NestedVar.new(bar, baz)])
    env = {
        'foo' => -> (*) {},
        'bar' => {}
    }
    assert_missing ['bar', 'baz'], sut.resolve(env)
  end

  test 'function with function and args' do
    sut = Grammar::Function.new(foo, [Grammar::Var.new(bar), Grammar::Function.new(baz, [Grammar::Var.new(Grammar::Token.new('buzz'))])])
    env = {
        'foo' => -> (*) {},
    }
    assert_missing ['bar'], sut.resolve(env)
    assert_missing_function 'baz', sut.resolve(env)
  end

end