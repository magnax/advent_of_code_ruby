require 'pry'

test_input = File.readlines('2023_Day_4_test_input.txt').map(&:strip)
test_result = 13

def process(input)
  input.map do |line|
    process_line(line)
  end.sum
end

def process_line(string)
  numbers = string.split(': ').last
  (winners, mine) = numbers.split(' | ')
  points = (winners.split(' ').map(&:strip) & mine.split(' ').map(&:strip)).reduce(1) { |acc, el| acc * 2 }
  points / 2
end

if ENV['SHOW_TEST']&.downcase == 'y'
  result = process(test_input)
  puts "Expected result: #{test_result}, actual: #{result.inspect}"
end

input = File.readlines('2023_Day_4_input.txt').map(&:strip)
result = process(input)

puts 'Advent Of Code 2023 - Day 4 Part 1'
puts "Result: #{result}"

# # Part 2:
test_result = 30

def process2(input)
  win = 0
  original_pile = process_cards_to_hashes(input)
  processed_pile = original_pile
  begin
    win += 1
    card = processed_pile.shift
    (card[:winners] & card[:mine]).each_with_index do |el, i|
      card_id = 1 + i + card[:id]
      processed_pile << original_pile.find { |el| el[:id] == card_id }
    end
  end while processed_pile.any?
  win
end

def process_cards_to_hashes(input)
  input.map do |string|
    (id, rest) = string.split(': ')
    (winners, mine) = rest.split(' | ')
    {
      id: id.match(/Card\s+(\d+)/)[1].to_i,
      winners: winners.split(' ').map(&:strip),
      mine: mine.split(' ').map(&:strip)
    }
  end
end

if ENV['SHOW_TEST']&.downcase == 'y'
  result = process2(test_input)
  puts "Expected result: #{test_result}, actual: #{result}"
end

input = File.readlines('2023_Day_4_input.txt').map(&:strip)
result = process2(input)

puts 'Advent Of Code 2023 - Day 4 Part 2'
puts "Result: #{result}"

