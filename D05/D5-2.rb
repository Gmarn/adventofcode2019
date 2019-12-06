file = File.read('input.txt')
array = file.split(',')

@program = array.dup.map { |e| e.to_i }

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
    @program[values[2]] =
      parameter_mode(instruction[2], values[0]) + parameter_mode(instruction[1], values[1])
  when 2
    @program[values[2]] =
      parameter_mode(instruction[2], values[0]) * parameter_mode(instruction[1], values[1])
  when 3
    prompt = gets
    # prompt = 5
    @program[values[0]] = prompt.to_i
  when 4
    puts "Output: #{parameter_mode(instruction[2], values[0])}"
  when 5
    return parameter_mode(instruction[1], values[1]) unless parameter_mode(instruction[2], values[0]).zero?
    'Not jump'
  when 6
    return parameter_mode(instruction[1], values[1]) if parameter_mode(instruction[2], values[0]).zero?
    'Not jump'
  when 7
    if parameter_mode(instruction[2], values[0]) < parameter_mode(instruction[1], values[1])
      @program[values[2]] = 1
    else
      @program[values[2]] = 0
    end
  when 8
    if parameter_mode(instruction[2], values[0]) == parameter_mode(instruction[1], values[1])
      @program[values[2]] = 1
    else
      @program[values[2]] = 0
    end
  when 9
    puts 'Halt'
    return 'finished'
  end
end

def run_program(iterator)
  inst = instruction(@program[iterator])
  if [1, 2, 7, 8].include?(inst[-1])
    increment = 3
  elsif [5, 6].include?(inst[-1])
    increment = 2
  else
    increment = 1
  end

  result = run_instruction(inst, @program[(iterator + 1)..(iterator + increment)])
  if result == 'finished'
    return
  elsif [5, 6].include?(inst[-1]) && result != 'Not jump'
    iterator = result
    run_program(iterator)
  else
    iterator += increment + 1
    run_program(iterator)
  end
end

run_program(0)
