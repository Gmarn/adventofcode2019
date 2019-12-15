class Intcode
  def initialize(program) #, setting, input)
    @program = program
    @output = []
    # @setting = setting
    # @input = input
    @set_setting = true
    @set_input = true
    @relative_base = 0
  end

  def instruction(num)
    array = num.to_s.split(/d*/).map { |e| e.to_i }
    (5 - array.length).times { |a| array.insert(0, 0) }
    array
  end

  def parameter_mode(mode, value)
    case mode
    when 1
      value
    when 2
      @program[value + @relative_base].to_i
    else
      @program[value].to_i
    end
  end

  def run_instruction(instruction, values)
    puts "#{instruction}" if instruction[0] != 0
    puts "#{instruction} : #{values}"
    case instruction[-2..-1].join()
    when '01'
      @program[values[2]] =
        parameter_mode(instruction[2], values[0]) + parameter_mode(instruction[1], values[1])
    when '02'
      @program[values[2]] =
        parameter_mode(instruction[2], values[0]) * parameter_mode(instruction[1], values[1])
    when '03'
      # puts "Values: #{values} and Instruction #{instruction}"
      # if @set_setting
      #   prompt = @setting
      #   @set_setting = false
      # elsif @set_input
      #   prompt = @input
      #   @set_input = false
      # else
      #   prompt = @output[-1]
      # end
      puts "prompt: "
      # puts instruction
      puts "Relative base: #{@relative_base}"
      puts "Value[0]: #{values[0]} / mode response: #{parameter_mode(instruction[2], values[0])}"
      prompt = gets
      # @program[parameter_mode(instruction[2], values[0])] = prompt.to_i ### To verify n day 07
      @program[63] = prompt.to_i ### To verify n day 07
      # @program[values[0]] = prompt.to_i ### To verify n day 07
    when '04'
      puts "Output: #{parameter_mode(instruction[2], values[0])}"
      @output << parameter_mode(instruction[2], values[0])
    when '05'
      return parameter_mode(instruction[1], values[1]) unless parameter_mode(instruction[2], values[0]).zero?
      'Not jump'
    when '06'
      return parameter_mode(instruction[1], values[1]) if parameter_mode(instruction[2], values[0]).zero?
      'Not jump'
    when '07'
      if parameter_mode(instruction[2], values[0]) < parameter_mode(instruction[1], values[1])
        # @program[parameter_mode(instruction[0], values[2])] = 1
        @program[values[2]] = 1
      else
        # @program[parameter_mode(instruction[0], values[2])] = 0
        @program[values[2]] = 0
      end
    when '08'
      if parameter_mode(instruction[2], values[0]) == parameter_mode(instruction[1], values[1])
        # @program[parameter_mode(instruction[0], values[2])] = 1
        @program[values[2]] = 1
      else
        # @program[parameter_mode(instruction[0], values[2])] = 0
        @program[values[2]] = 0
      end
    when '09'
      @relative_base += parameter_mode(instruction[2], values[0])
      puts @relative_base
    when '99'
      puts 'Halt'
      return 'finished'
    end
  end

  def run_program(iterator)
    inst = instruction(@program[iterator])
    if ['01', '02', '07', '08'].include?(inst[-2..-1].join())
      increment = 3
    elsif ['05', '06'].include?(inst[-2..-1].join())
      increment = 2
    else
      increment = 1
    end

    result = run_instruction(inst, @program[(iterator + 1)..(iterator + increment)])
    # puts "Iterator values 2: #{@program[(iterator + 1)..(iterator + increment)]}"
    # puts "Program: #{@program}"
    # puts "Relative base: #{@relative_base}"
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
