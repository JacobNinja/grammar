require File.expand_path('../../lib/grammar', __FILE__)

formula = 'subtract(foo.bar.baz, foo.bar.buzz)'

def print_results(formula, env)
  result =  Grammar.process(formula, env)
  result.missing.vars.each do |var|
    puts "Missing var: #{var.join('.')}"
  end
  result.missing.functions.each do |func|
    puts "Missing function: #{func}"
  end
end

puts 'Test 1: missing buzz'
e = {
    'subtract' => -> (a, b) { a - b },
    'foo' => {
        'bar' => {
            'baz' => 60,
        }
    }
}
print_results(formula, e)

puts 'Test 2: missing baz and buzz'
e = {
    'subtract' => -> (a, b) { a - b },
    'foo' => {
        'bar' => {}
    }
}
print_results(formula, e)

puts 'Test 3: missing subtract function and baz'
e = {
    'foo' => {
        'bar' => {
            'buzz' => 60,
        }
    }
}
print_results(formula, e)