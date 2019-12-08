file = File.read('input.txt')
@knots = file.split("\n").map { |kn| kn.split(')') }

puts @knots[0]

def run_program(object, sum)
  orbits = @knots.select { |kn| kn[0] == object }
  puts "#{orbits}"
  @checksum += sum
  orbits.each do |orbit|
    run_program(orbit[1], sum + 1)
  end
end

@checksum = 0
run_program('COM', 0)
puts @checksum
