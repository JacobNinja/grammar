require File.expand_path('../../lib/grammar', __FILE__)

env = {
    'add' => -> (a, b) { a + b },
    'foo' => {
        'bar' => 10,
        'baz' => 6
    }
}

puts Grammar.process(<<-RUBY, env)
add(foo.bar, foo.baz)
RUBY