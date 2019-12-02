file = File.read('input.txt')
array = file.split(',').map { |e| e.to_i }

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
  if program_step_calculation(batch[0], batch[1], batch[2], batch[3]) == 'finished'
    return
  else
    iterator += 1
    num = 4 * iterator
    run_program(@program[num..(num + 3)], iterator)
  end
end

def find_inflection(result)
  result.each_with_index do |u, index|
    if u.positive?
      return index
    end
  end
end

result = []
(0..99).each do |i|
  @program = array.dup
  @program[1] = i
  @program[2] = 2
  run_program(@program[0..3], 0)
  result << @program[0] - 19690720
end

indI = find_inflection(result)

puts indI

result = []
(0..99).each do |j|
  @program = array.dup
  @program[1] = indI - 1
  @program[2] = j
  run_program(@program[0..3], 0)
  result << @program[0] - 19690720
end

indJ = find_inflection(result)

puts indI*100 + (indJ - 1)
