file = File.read('input.txt')
array = file.split("\n")
array.map! { |a| a.split(',') }
moons = array.each_with_object([]) do |coord, acc|
  acc << { x: coord[0].split('=')[1].to_i,
           y: coord[1].split('=')[1].to_i,
           z: coord[2].split('=')[1].to_i }
end
@moons_init = moons.dup

def apply_gravity_on_coord(coord1, coord2, velocities, i, j, axis)
  if coord1 < coord2
    velocities[i][axis] += 1
    velocities[j + i + 1][axis] -= 1
  elsif coord1 > coord2
    velocities[i][axis] -= 1
    velocities[j + i + 1][axis] += 1
  end
  velocities
end

def apply_gravity(coordinates, velocities)
  coordinates.each_with_index do |coord, index|
    coordinates[index + 1..-1].each_with_index do |c, jndex|
      velocities = apply_gravity_on_coord(coord[:x], c[:x], velocities, index, jndex, :x)
      velocities = apply_gravity_on_coord(coord[:y], c[:y], velocities, index, jndex, :y)
      velocities = apply_gravity_on_coord(coord[:z], c[:z], velocities, index, jndex, :z)
    end
  end
  velocities
end

def apply_velocity(coordinates, velocities)
  new_coord = []
  coordinates.each_with_index do |coord, index|
    new_coord << { x: coord[:x] + velocities[index][:x],
                   y: coord[:y] + velocities[index][:y],
                   z: coord[:z] + velocities[index][:z] }
  end
  new_coord
end

def run_step(coords, vels)
  new_vels = apply_gravity(coords, vels)
  new_coords = apply_velocity(coords, new_vels)
  return [new_coords, new_vels]
end

def verify_period(step, moon_pos, velocities)
  moon_pos.each_with_index do |moon, index|
    [:x, :y, :z].each do |axis|
      @periodes[index][axis] << step if moon[axis] == @moons_init[index][axis] && velocities[index][axis] == 0
    end
  end
end

def collect_periods
  @periodes.each_with_object([]) do |periods, acc|
    [:x, :y, :z].each do |axis|
      acc << find_one(periods[axis])
    end
  end
end

def find_one(ax_periods)
  ax_periods.each do |ax_p|
    if have_multiple?(ax_p, ax_periods)
      return ax_p
    else
      next
    end
  end
end

def reduce_lcm(periods)
  lcm_total = periods[0]
  periods.each do |p|
    lcm_total = p.lcm(lcm_total)
  end
  lcm_total
end

def have_multiple?(value, array)
  array.each do |element|
    return true if value * 2 == element
  end
  false
end

vel = []
(moons.length).times { vel << { x: 0, y: 0, z: 0 } }

@periodes = [{ x: [], y: [], z: [] },
             { x: [], y: [], z: [] },
             { x: [], y: [], z: [] },
             { x: [], y: [], z: [] }]

(1..500000).each do |step|
  result = run_step(moons, vel)
  verify_period(step, result[0], result[1])
  moons = result[0]
  vel = result[1]
end

@periodes.each { |p| puts "#{p}" }
puts "#{collect_periods}"
puts "#{reduce_lcm(collect_periods)}"
