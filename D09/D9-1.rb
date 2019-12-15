require './intcode-computer'

file = File.read('input.txt')
array = file.split(',')

program = array.dup.map { |e| e.to_i }

# Intcode.new(program, setting, input).run_program(0)
result = Intcode.new(program).run_program(0)
puts "#{result}"
