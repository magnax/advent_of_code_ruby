require 'pry'

DAY = '6'

test_input = File.readlines("2023_Day_#{DAY}_test_input.txt").map(&:strip)
input =      File.readlines("2023_Day_#{DAY}_input.txt").map(&:strip)

test_result_1 = 288
test_result_2 = 71503

class AoC
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def run_part_1!
    calculate(games)
  end

  def run_part_2!
    calculate(games_2)
  end

  private

  def calculate(games)
    won_count = []
    games.each do |game|
      i = 0
      (1..game[:time].to_i).map do |el|
        d = (game[:time] - el) * el
        i += 1 if d > game[:dist]
      end
      won_count << i
    end
    won_count.reduce(1) { |acc, el| el * acc }
  end

  def games
    time_distance_table.first.map.with_index do |el, i|
      { time: el, dist: time_distance_table.last[i] }
    end
  end

  def games_2
    tt = time_distance_table.first.map.with_index do |el, i|
      { time: el, dist: time_distance_table.last[i] }
    end
    games = tt.reduce({ time: '', dist: ''}) do |acc, el|
      { time: acc[:time] + el[:time].to_s, dist: acc[:dist] + el[:dist].to_s }
    end

    [{ time: games[:time].to_i, dist: games[:dist].to_i}]
  end

  def time_distance_table
    input.map { |el| el.split(' ').map(&:strip).slice(1, 999).map(&:to_i) }
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
