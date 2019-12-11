file = File.read('input.txt')
@wide = 25
@tall= 6
size = @wide * @tall
pixels = file.chars.each_slice(size).map(&:join)
pixels.pop

def build_retangle(pixels)
  pixels.each_with_object([]) do |layer, acc|
    acc << layer.chars.each_slice(@wide).map(&:join)
  end
end

def select_color(i, j, rectangles)
  rectangles.each do |rectangle|
    if rectangle[i][j] == '1'
      return '#'
    elsif rectangle[i][j] == '0'
      return ' '
    end
  end
  return '2'
end

def run_program(pixels)
  rectangles = build_retangle(pixels)
  (0..@tall - 1).each_with_object([]) do |i, acc_i|
    line = (0..@wide - 1).each_with_object([]) do |j, acc_j|
      acc_j << select_color(i, j, rectangles).to_s
    end
    acc_i << line
  end
end

result = run_program(pixels)
result = result.map { |r| puts r.join() }
