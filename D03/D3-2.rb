file = File.read('input.txt')
paths = file.split("\n")

path1 = paths[0].split(',')
path2 = paths[1].split(',')

@central_port = { x: 0, y: 0 }

def next_point(move, pos)
  case move[0]
  when "R"
    { x: pos[:x] + move[1..-1].to_i, y: pos[:y] }
  when "L"
    { x: pos[:x] - move[1..-1].to_i, y: pos[:y] }
  when "U"
    { x: pos[:x], y: pos[:y] + move[1..-1].to_i }
  when "D"
    { x: pos[:x], y: pos[:y] - move[1..-1].to_i }
  end
end

def create_segment(pos_a, pos_b)
  { a: { x: pos_a[:x], y: pos_a[:y] }, b: { x: pos_b[:x], y: pos_b[:y] } }
end

def separate_segments(segments)
  segments.each_with_object({ horizontal: [], vertical: [], other: [] }) do |segment, acc|
    if segment[:a][:x] == segment[:b][:x]
      acc[:vertical] << segment
    elsif segment[:a][:y] == segment[:b][:y]
      acc[:horizontal] << segment
    else
      acc[:other] << segment
    end
  end
end

def moves_to_segments(path)
  segments = []
  pos = @central_port.dup
  path.each do |e|
    new_pos = next_point(e, pos)
    segments << create_segment(pos, new_pos)
    pos = new_pos
  end
  segments
end

def cross_points(verticals, horizontals)
  verticals.each_with_object([]) do |v, acc|
    horizontals.each do |h|
      if v[:a][:x] < [h[:a][:x], h[:b][:x]].max && v[:a][:x] > [h[:a][:x], h[:b][:x]].min
        if h[:a][:y] < [v[:a][:y], v[:b][:y]].max && h[:a][:y] > [v[:a][:y], v[:b][:y]].min
          acc << { x: v[:a][:x], y: h[:a][:y] }
        end
      end
    end
  end
end

def point_on_segment?(point, segment)
  if segment[:a][:x] == segment[:b][:x] && segment[:a][:x] == point[:x]
    point[:y] < [segment[:a][:y], segment[:b][:y]].max && point[:y] > [segment[:a][:y], segment[:b][:y]].min
  elsif segment[:a][:y] == point[:y]
    point[:x] < [segment[:a][:x], segment[:b][:x]].max && point[:x] > [segment[:a][:x], segment[:b][:x]].min
  else
    false
  end
end

def distance_to_point(point, segments)
  i = 0
  steps_acc = 0
  while !point_on_segment?(point, segments[i])
    steps_acc += (segments[i][:a][:x] - segments[i][:b][:x]).abs + (segments[i][:a][:y] - segments[i][:b][:y]).abs
    i += 1
  end
  steps_acc += (segments[i][:a][:x] - point[:x]).abs + (segments[i][:a][:y] - point[:y]).abs
end

segments1 = separate_segments(moves_to_segments(path1))
segments2 = separate_segments(moves_to_segments(path2))

results1 = cross_points(segments1[:vertical], segments2[:horizontal])
results2 = cross_points(segments2[:vertical], segments1[:horizontal])

results = results1 + results2

segments1 = moves_to_segments(path1)
segments2 = moves_to_segments(path2)

steps = results.each_with_object([]) do |result, acc|
   acc << distance_to_point(result, segments1) + distance_to_point(result, segments2)
end

puts steps.min
