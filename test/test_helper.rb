require 'test/unit'
require File.expand_path('../../lib/grammar', __FILE__)

class GrammarTest < Test::Unit::TestCase

  attr_reader :foo, :bar, :baz
  def setup
    @foo = Grammar::Token.new('foo', 1, 0)
    @bar = Grammar::Token.new('bar')
    @baz = Grammar::Token.new('baz')
  end

end