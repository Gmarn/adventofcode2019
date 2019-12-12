file = File.read('input.txt')
asteroid_map = file.split("\n")
@wide = asteroid_map[0].length
@tall= asteroid_map.length

def build_ref_coordinates(asteroid_map)
  i = 0
  asteroid_map.each_with_object([]) do |line, acc|
    (0..@wide - 1).each do |j|
      next unless line[j] == '#'
      acc << { x: j, y: @tall - i - 1 }
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

def cart_to_polar(x, y)
  m = Math.sqrt(x**2 + y**2)
  { r: m.round(5), a: (2 * Math.atan(y / (x + m))).round(5) }
end

def new_mapping(old_map, new_center)
  old_map.map { |c| { x: c[:x] - new_center[:x], y: c[:y] - new_center[:y] } }
end

def separate_sector(coordinates)
  coordinates.each_with_object({ fourth: [], other: [] }) do |coordinate, acc|
    if coordinate[:a] > Math::PI / 2
      acc[:fourth] << coordinate
    else
      acc[:other] << coordinate
    end
  end
end

def find_nexts(asteroids, counter)
  sorted_asteroids = asteroids.reject { |hsh| hsh[:a].nan? }.sort_by { |hsh| hsh[:a] }.reverse
  i = 0
  while i < sorted_asteroids.length
    j = 1
    while sorted_asteroids[i] == sorted_asteroids[j] && j < sorted_asteroids.length
      j += 1
    end
    i += j
    return sorted_asteroids[i] if i >= counter
  end
  return i
end

def restore_on_orignal_map(result, laser_coord)
  { x: result[:r] * Math.cos(result[:a]) + laser_coord[:x],
    y: (@tall - 1) - (result[:r] * Math.sin(result[:a]) + laser_coord[:y]) }
end

def run_laser(asteroid_map, laser_coord)
  coordinates = new_mapping(build_ref_coordinates(asteroid_map).reject { |c| c == laser_coord }, laser_coord)
  polar_coord = coordinates.map { |c| cart_to_polar(c[:x], c[:y]) }
  sectors =  separate_sector(polar_coord)
  result_sector_1 = find_nexts(sectors[:other], 200) + 1
  result_visual = find_nexts(sectors[:fourth], 200 - result_sector_1)
  restore_on_orignal_map(result_visual, laser_coord)
end

results = run_program(asteroid_map)
laser_coord = results.sort_by { |hsh| hsh[:visible_asteroides] }[-1][:coord]
result = run_laser(asteroid_map, laser_coord)
puts result
