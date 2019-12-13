file = File.read('input.txt')
asteroid_map = file.split("\n")
@wide = asteroid_map[0].length
@tall= asteroid_map.length

def build_ref_coordinates(asteroid_map)
  i = 0
  asteroid_map.each_with_object([]) do |line, acc|
    (0..@wide - 1).each do |j|
      next unless line[j] == '#'
      acc << { x: j, y: i } # @tall - i -1 }
    end
    i += 1
  end
end

def build_vector(coord_a, coord_b)
  { x: coord_b[:x] - coord_a[:x],
    y: coord_b[:y] - coord_a[:y] }
end

def collinear?(v_1, v_2)
  return false unless v_1[:x] * v_2[:y] == v_1[:y] * v_2[:x]
  v_1[:x] * v_2[:x] >= 0 && v_1[:y] * v_2[:y] >= 0
end

def is_hide?(v, selected_vectors)
  selected_vectors.each do |vector|
    return true if collinear?(v, vector)
  end
  false
end

def visible_count(array, coord) #, selected_vectors)
  array.each_with_object([]) do |asteroid, acc|
    v = build_vector(coord, asteroid)
    acc << v unless is_hide?(v, acc)
  end.length
end

def run_program(asteroid_map)
  coordinates = build_ref_coordinates(asteroid_map)
  coordinates.each_with_object([]) do |coordinate, acc|
    acc << { coord: coordinate, visible_asteroides: visible_count(coordinates.reject { |c| c == coordinate }, coordinate) }
  end
end

result = run_program(asteroid_map)
puts "#{result.sort_by { |hsh| hsh[:visible_asteroides] }[-1]}"
