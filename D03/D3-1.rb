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
  separate_segments(segments)
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

segments1 = moves_to_segments(path1)
segments2 = moves_to_segments(path2)

results1 = cross_points(segments1[:vertical], segments2[:horizontal])
results2 = cross_points(segments2[:vertical], segments1[:horizontal])
results = results1 + results2

result = results.map { |p| p[:x].abs + p[:y].abs }
puts result.min
