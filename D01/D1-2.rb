file = File.read('input.txt')
array = file.split(' ')

puts array[0]

def negative_fuel?(fuel)
  return true if fuel <= 0
  false
end

def mass_to_fuel(mass)
  (mass/3.0).to_i - 2
end

def module_fuel(mass)
  fuel = mass_to_fuel(mass.to_i)
  if negative_fuel?(fuel)
    return @sum_fuel
  else
    @sum_fuel += fuel
    module_fuel(fuel)
  end
end


total_fuel = 0
# stock = nil
array.each do |f|
  @sum_fuel = 0
  total_fuel += module_fuel(f)
#   total_fuel += mass_to_fuel(f.to_i)
end
puts total_fuel
# puts stock
