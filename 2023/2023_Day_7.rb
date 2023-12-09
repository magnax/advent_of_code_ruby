require 'pry'

DAY = '7'

test_input = File.readlines("2023_Day_#{DAY}_test_input.txt").map(&:strip)
input =      File.readlines("2023_Day_#{DAY}_input.txt").map(&:strip)

test_result_1 = 6440
test_result_2 = 5905

class AoC
  attr_reader :input, :part

  HIGH_CARD = 0
  ONE_PAIR = 1
  TWO_PAIR = 2
  THREE_OF_A_KIND = 3
  FULL_HOUSE = 4
  FOUR_OF_A_KIND = 5
  FIVE_OF_A_KIND = 6

  def initialize(input)
    @input = input
  end

  def run_part_1!
    @part = 1
    reduce_hands
  end

  def run_part_2!
    @part = 2
    reduce_hands
  end

  private

  def reduce_hands
    ranked = []
    (0..6).each do |hand_type|
      hands.select do |el|
        el[:type] == hand_type
      end.sort_by { |el| el[:sort_key] }.each { |el| ranked << el }
    end
    ranked = ranked.map.with_index { |el, i| el.merge(rank: i + 1) }
    ranked.reduce(0) { |acc, el| acc + el[:rank] * el[:bid].to_i }
  end

  def hands
    @hands ||= 
      input.map do |hand|
        (cards, bid) = hand.split(' ').map(&:strip)
        {
          cards: cards,
          bid: bid,
          rank: 0,
          type: determine_hand_type(cards, part),
          sort_key: sort_key(cards, part)
        }
      end
  end

  def determine_hand_type(cards, part)
    return hand_type(cards) if part == 1 || cards.index('J').nil?
    return FIVE_OF_A_KIND if cards == 'JJJJJ'

    repls = cards.split('').uniq.reject { |el| el == 'J' }
    repls.map { |ch| hand_type(cards.tr('J', ch)) }.max
  end

  def hand_type(cards)
    cards_array = cards.split('').sort
    case cards_array.uniq.length
    when 1
      FIVE_OF_A_KIND
    when 2
      if cards_array.uniq.map { |el| cards_array.select { |el1| el == el1 }.count }.max == 4
        FOUR_OF_A_KIND
      else
        FULL_HOUSE
      end
    when 3
      if cards_array.uniq.map { |el| cards_array.select { |el1| el == el1 }.count }.max == 3
        THREE_OF_A_KIND
      else
        TWO_PAIR
      end
    when 4
      ONE_PAIR
    else
      HIGH_CARD
    end
  end

  def sort_key(cards, part = 1)
    return cards.tr('TJQKA', 'abcde') if part == 1

    cards.tr('TJQKA', 'a1cde')
  end
end

if ARGV[0] == '1' || ARGV[0].nil?
  puts "Advent Of Code 2023 - Day #{DAY} Part 1"

  if ENV['SHOW_TEST']&.downcase == 'y'
    result = AoC.new(test_input).run_part_1!
    puts "Expected result: #{test_result_1}, actual: #{result.inspect}"
  else
    result = AoC.new(input).run_part_1!
    puts "Result: #{result}"
  end
end

if ARGV[0] == '2' || ARGV[0].nil?
  puts "Advent Of Code 2023 - Day #{DAY} Part 2"

  if ENV['SHOW_TEST']&.downcase == 'y'
    result = AoC.new(test_input).run_part_2!
    puts "Expected result: #{test_result_2}, actual: #{result}"
  else
    result = AoC.new(input).run_part_2!
    puts "Result: #{result}"
  end
end
