file = File.read('input.txt')
array = file.split(',')

@program = array.dup.map { |e| e.to_i }

puts "#{@program[0..3]}"

def instruction(num)
  array = num.to_s.split(/d*/).map { |e| e.to_i }
  (5 - array.length).times { |a| array.insert(0, 0) }
  array
end

def parameter_mode(mode, value)
  return value if mode == 1
  @program[value].to_i
end

def run_instruction(instruction, values)
  case instruction[-1]
  when 1
    puts instruction if instruction[0] == 1
    @program[values[2]] =
      parameter_mode(instruction[2], values[0]) + parameter_mode(instruction[1], values[1])
  when 2
    puts instruction if instruction[0] == 1
    @program[values[2]] =
      parameter_mode(instruction[2], values[0]) * parameter_mode(instruction[1], values[1])
  when 3
    prompt = gets
    # prompt = 1
    @program[values[0]] = prompt.to_i
  when 4
    puts "Output: #{parameter_mode(instruction[2], values[0])}"
  when 9
    puts 'Halt'
    return 'finished'
  end
end

def run_program(iterator)
  inst = instruction(@program[iterator])
  if [1, 2].include?(inst[-1])
    increment = 3
  else
    increment = 1
  end

  if run_instruction(inst, @program[(iterator + 1)..(iterator + increment)]) == 'finished'
    return
  else
    iterator += increment + 1
    run_program(iterator)
  end
end

run_program(0)
