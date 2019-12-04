first = "359282"
last = "820401"

def build_array(digit)
  [digit[0].to_i, digit[1].to_i, digit[2].to_i, digit[3].to_i, digit[4].to_i, digit[5].to_i]
end

def part_of_larger_group?(array)
  hash = array.each_with_object({}) do |a, acc|
    if acc[:"#{a.to_s}"]
      acc[:"#{a.to_s}"] += 1
    else
      acc[:"#{a.to_s}"] = 1
    end
  end

  # Seems the traduction of the rules is exist a pair, not what I understood first
  return true if hash.value?(2)

  # For me the rules specify more the following possibilities but seems rules before is the right one
  #
  # repeatition = hash.values.sort
  # return true if repeatition == [1, 2, 3] || repeatition == [1, 1, 2, 2] || repeatition == [2, 4] || repeatition == [6] || repeatition == [3, 3] || repeatition == [2, 2, 2]

  false
end

def possible_password?(digit)
  base_array = build_array(digit)
  return false if base_array == build_array(digit).uniq
  return false if base_array != build_array(digit).sort
  return part_of_larger_group?(base_array)
end

results = (first.to_i..last.to_i).each_with_object([]) do |e, acc|
  next unless possible_password?(e.to_s)
  acc << e
end

puts results.count
