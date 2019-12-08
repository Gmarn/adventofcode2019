file = File.read('input.txt')
@knots = file.split("\n").map { |kn| kn.split(')') }

@path_you = []
@path_san = []

def run_program(object, path)
  orbits = @knots.select { |kn| kn[0] == object }
  orbits.each do |orbit|
    path << object
    if orbit[1] == 'YOU'
      @path_you = path.dup
    elsif orbit[1] == 'SAN'
      @path_san = path.dup
    end
    run_program(orbit[1], path.dup)
  end
end

def reduce_path
  i = 0
  while @path_you[i] == @path_san[i]
    i += 1
  end
  @path_san = @path_san[i..-1]
  @path_you = @path_you[i..-1]
end

run_program('COM', [])
puts "#{@path_san.uniq!}"
puts "#{@path_you.uniq!}"
reduce_path

puts @path_you.length + @path_san.length
