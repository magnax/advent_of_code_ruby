require 'pry'

GAME = {
  blue: 14,
  green: 13,
  red: 12
}

def process_line(string)
  (game, showings) = string.split(':')
  {
    id: game.split(' ').last,
    showings: showings.split(';').map(&:strip).map { |s| normalize_colors(s) }
  }
end

def normalize_colors(string)
  ss = string.split(',').map(&:strip)
  .map do |s|
    el = s.split(' ')
    [el.last.to_sym, el.first.to_i]
  end.to_h

  { blue: 0, green: 0, red: 0 }.merge ss
end

def determine_possible_game(game_hash)
  results = game_hash[:showings].map do |gh|
    gh.map { |k,v| GAME[k] >= v }.all? { |el| el == true }
  end
  
  return game_hash[:id].to_i if results.all? { | el| el == true }

  # puts "=====\n#{game_hash.inspect}\n=====\n"
  0
end

def determine_minimum_cubes_power(game_hash)
  blue = 0
  green = 0
  red = 0

  results = game_hash[:showings].each do |gh|
    blue = gh[:blue] if gh[:blue] > blue
    green = gh[:green] if gh[:green] > green
    red = gh[:red] if gh[:red] > red
  end
  blue * green * red
end

test = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

test_result = 8

def process(input)
  input.map do |line|
    process_line(line)
  end
  .map do |game_hash|
    determine_possible_game(game_hash)
  end
  .sum
end

if ENV['SHOW_TEST']&.downcase == 'y'
  result = process(test.split("\n"))
  puts "Expected result: #{test_result}, actual: #{result}"
end

input = File.readlines('2023_Day_2a_input.txt').map(&:strip)
result = process(input)

puts 'Advent Of Code 2023 - Day 2 Part 1'
puts "Result: #{result}"

# Part 2:
test_result = 2286

def process2(input)
  input.map do |line|
    process_line(line)
  end
  .map do |game_hash|
    determine_minimum_cubes_power(game_hash)
  end
  .sum
end

if ENV['SHOW_TEST']&.downcase == 'y'
  result = process2(test.split("\n"))
  puts "Expected result: #{test_result}, actual: #{result}"
end

input = File.readlines('2023_Day_2a_input.txt').map(&:strip)
result = process2(input)

puts 'Advent Of Code 2023 - Day 2 Part 1'
puts "Result: #{result}"
