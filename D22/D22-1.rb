require './shuffler'

file = File.read('input.txt')
rules = file.split("\n")
# puts "Rules: #{rules}"

def creater_ruler(rules)
  rules.each_with_object([]) do |rule, acc|
    splitted = rule.split(" ")
    if splitted[0] == "deal"
      if splitted[2] == 'increment'
        acc << { rule: 'deal_increment', value: splitted[-1].to_i }
      else
        acc << { rule: 'new_stack' }
      end
    else
      acc << { rule: 'cut', value: splitted[-1].to_i }
    end
  end
end

# puts "Rules: #{creater_ruler(rules)}"

def run_shuffle(rules)
  deck =* (0..10006)
  rules.each do |rule|
    deck = Shuffler.new(rule, deck).choose_method
    puts "Deck: #{deck}"
  end
  deck
end

# 4071 too high
# 3701 too high
result = run_shuffle(creater_ruler(rules))
puts "Result: #{result}"
puts "Result: #{result[2019 - 1..2019 + 1]}"
