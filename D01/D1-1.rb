file = File.read('input.txt')
array = file.split(' ')

puts array[0]


init = 0
# stock = nil
array.each do |f|
  result = (f.to_i/3.0).to_i - 2
#   stock = init + freq
  init += result
end
puts init
# puts stock
