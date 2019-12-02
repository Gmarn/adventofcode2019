file = File.read('input.txt')
array = file.split(',')

@program = array.dup.map { |e| e.to_i }
@program[1] = 12
@program[2] = 2

puts "#{@program[0..3]}"

def program_step_calculation(opcode, pos1, pos2, pos_result)
  if opcode == 1
    @program[pos_result] = @program[pos1] + @program[pos2]
  elsif opcode == 2
    @program[pos_result] = @program[pos1] * @program[pos2]
  elsif opcode == 99
    return 'finished'
  end
end

def run_program(batch, iterator)
  puts "#{iterator} : #{batch}"
  if program_step_calculation(batch[0], batch[1], batch[2], batch[3]) == 'finished'
    return
  else
    iterator += 1
    num = 4 * iterator
    run_program(@program[num..(num + 3)], iterator)
  end
end

run_program(@program[0..3], 0)
puts "#{@program[0..3]}"
puts "#{@program[8..11]}"

puts @program[0]
