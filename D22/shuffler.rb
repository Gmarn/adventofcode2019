class Shuffler
  def initialize(rule, deck)
    @rule = rule
    @deck = deck
  end

  def choose_method
    puts "Rule: #{@rule}"
    case @rule[:rule]
    when 'cut'
      cut_deck
    when 'new_stack'
      @deck.reverse
    when 'deal_increment'
      deal_increment
    end
  end

  private

  def cut_deck
    value = @rule[:value]
    if value.positive?
      cut_cards = @deck[0..value - 1]
      @deck[value..-1] += cut_cards
    else
      cut_cards = @deck[value..-1]
      cut_cards += @deck[0..value - 1]
    end
  end

  def deal_increment
    increment = 0
    modulo = @deck.length
    (0..modulo - 1).each_with_object([]) do |i, acc|
      acc[increment % modulo] = @deck[i]
      increment += @rule[:value]
    end
  end
end
