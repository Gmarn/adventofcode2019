require './intcode-computer'

file = File.read('input.txt')
array = file.split(',')

program = array.dup.map { |e| e.to_i }

possibilities = (0..4).to_a.permutation(5)

def run_a_possibility(phase, program)
  input = 0
  phase.each do |setting|
    output = Intcode.new(program, setting, input).run_program(0)
    puts output
    input = output[-1]
  end
  input
end

result = possibilities.each_with_object([]) do |p, acc|
  signal = run_a_possibility(p, program.dup)
  acc << { phase: p, output: signal }
end

puts "#{result.sort_by { |hsh| hsh[:output] }[-1]}"
