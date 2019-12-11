file = File.read('input.txt')
wide = 25
tall= 6
size = wide * tall
pixels = file.chars.each_slice(size).map(&:join)

puts pixels.length()

def count_zeros(pixels)
  num = 0
  pixels.each_with_object([]) do |layer, acc|
    acc << { layer_num: num, zeros: layer.count('0')}
    num += 1
  end
end

def run_program(pixels)
  zeros_by_layers = count_zeros(pixels)
  zeros_by_layers.sort_by! { |hsh| hsh[:zeros] }
  max_zeros_layer = zeros_by_layers[0][:layer_num]
  pixels[max_zeros_layer].count('1') * pixels[max_zeros_layer].count('2')
end

pixels.pop
result = run_program(pixels)
puts result
