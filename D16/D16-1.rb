file = File.read('input.txt')
@base_pattern = [0, 1, 0, -1]
@base_size = @base_pattern.length
signal = file.split(/d*/)
signal.pop

def generate_pattern(pattern, length, rep, item_pos_pattern = -1)
  return pattern if pattern.length == length
  item_pos_pattern += 1 if pattern.length % rep == 0
  pattern << @base_pattern[item_pos_pattern % @base_size]
  generate_pattern(pattern, length, rep, item_pos_pattern)
end

def build_all_patterns(signal)
  (0..signal.length - 1).each_with_object([]) do |i, acc|
    acc << generate_pattern([], signal.length + 1, i + 1).drop(1)
  end
end

def output(pattern, signal)
  (0..pattern.length - 1).each_with_object([]) do |i, acc|
    acc << pattern[i] * signal[i].to_i
  end.reduce(:+).abs
end

def run_a_phase(signal)
  @all_patterns.each_with_object([]) do |pattern, acc|
    sum = output(pattern, signal)
    acc << sum.digits[0].to_s
  end
end

def run_phases(signal)
  new_signal = signal.dup
  100.times do
    new_signal = run_a_phase(new_signal)
  end
  new_signal
end

# puts "Sum: #{sum}"
@all_patterns = build_all_patterns(signal)
final_signal = run_phases(signal)
puts "#{final_signal[0..7]}"
puts "#{final_signal[0..7].join()}"
