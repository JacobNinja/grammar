require File.expand_path('../../lib/grammar', __FILE__)

env = {
    'functions' => {
      'add' => -> (*n) { n.reduce(:+) },
    },
    'foo' => 1,
    'bar' => 5,
    'baz' => 20
}

puts Grammar.process(<<-RUBY, env).value
add(foo, bar, baz)
RUBY