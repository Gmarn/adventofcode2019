require './intcode-computer'

file = File.read('input.txt')
array = file.split(',')

program = array.dup.map { |e| e.to_i }

possibilities = (5..9).to_a.permutation(5)

def run_a_possibility(phase, program, input)
  puts "#{phase}"
  phase.each do |setting|
    output = Intcode.new(program.dup, setting, input).run_program(0)
    puts "#{output}"
    input = output[-1]
  end
  input
end

results = possibilities.each_with_object([]) do |p, acc|
  signal = run_a_possibility(p, program.dup, 0)
  acc << { phase: p, output: signal }
end

result = results.sort_by { |hsh| hsh[:output] }[-1]
puts "#{result}"

feedback = 0
output_signal = 1
# while feedback < output_signal
#   feedback = output_signal
#   output_signal = run_a_possibility(result[:phase], program.dup, feedback)
#   puts output_signal
# end

1.times do
  output_signal = run_a_possibility(result[:phase], program.dup, feedback)
  feedback = output_signal
  puts feedback
end


