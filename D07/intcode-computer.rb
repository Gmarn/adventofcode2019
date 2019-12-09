class Intcode
  def initialize(program, setting, input)
    @program = program
    @output = []
    @setting = setting
    @input = input
    @set_setting = true
    @set_input = true
  end

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
      # puts "Values: #{values} and Instruction #{instruction}"
      # prompt = gets
      if @set_setting
        prompt = @setting
        @set_setting = false
      elsif @set_input
        prompt = @input
        @set_input = false
      else
        prompt = @output[-1]
      end
      puts "prompt: #{prompt}"
      @program[values[0]] = prompt.to_i
    when 4
      # puts "Output: #{parameter_mode(instruction[2], values[0])}"
      @output << parameter_mode(instruction[2], values[0])
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
    # puts "Iterator values 2: #{@program[(iterator + 1)..(iterator + increment)]}"
    if result == 'finished'
      @setting_set = false
      return @output
    elsif [5, 6].include?(inst[-1]) && result != 'Not jump'
      iterator = result
      run_program(iterator)
    else
      iterator += increment + 1
      run_program(iterator)
    end
  end
end
