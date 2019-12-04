first = "359282"
last = "820401"

def build_array(digit)
  [digit[0].to_i, digit[1].to_i, digit[2].to_i, digit[3].to_i, digit[4].to_i, digit[5].to_i]
end

def possible_password?(digit)
  base_array = build_array(digit)
  return false if base_array == build_array(digit).uniq
  return false if base_array != build_array(digit).sort
  true
end

results = (first.to_i..last.to_i).each_with_object([]) do |e, acc|
  next unless possible_password?(e.to_s)
  acc << e
end

puts results.count
