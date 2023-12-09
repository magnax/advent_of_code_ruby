require 'pry'

DAY = 'INSERT DAY HERE!'

test_input = File.readlines("2023_Day_#{DAY}_test_input.txt").map(&:strip)
input =      File.readlines("2023_Day_#{DAY}_input.txt").map(&:strip)

test_result_1 = 35
test_result_2 = 46

class AoC
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def run_part_1!
    "Part 1!"
  end

  def run_part_2!
    "Part 2!"
  end

  private
end


if ARGV[0] == '1' || ARGV[0].nil?
  puts "Advent Of Code 2023 - Day #{DAY} Part 1"

  if ENV['SHOW_TEST']&.downcase == 'y'
    result = AoC.new(test_input).run_part_1!
    puts "Expected result: #{test_result_1}, actual: #{result.inspect}"
  end

  result = AoC.new(input).run_part_1!
  puts "Result: #{result}"
end

if ARGV[0] == '2' || ARGV[0].nil?
  puts "Advent Of Code 2023 - Day #{DAY} Part 2"


  if ENV['SHOW_TEST']&.downcase == 'y'
    result = AoC.new(test_input).run_part_2!
    puts "Expected result: #{test_result_2}, actual: #{result}"
  end

  result = AoC.new(input).run_part_2!
  puts "Result: #{result}"
end
