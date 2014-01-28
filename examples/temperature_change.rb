require File.expand_path('../../lib/grammar', __FILE__)

env = {
    'subtract' => -> (a, b) { a - b },
    'furnace' => {
        'fan' => {
            'entering_temperature' => 60,
            'exiting_temperature' => 40,
        }
    }
}

puts Grammar.process(<<-RUBY, env)
subtract(furnace.fan.entering_temperature, furnace.fan.exiting_temperature)
RUBY