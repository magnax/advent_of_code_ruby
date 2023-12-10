require 'pry'

DAY = '9'

test_input = File.readlines("2023_Day_#{DAY}_test_input.txt").map(&:strip)
input =      File.readlines("2023_Day_#{DAY}_input.txt").map(&:strip)

test_result_1 = 114
test_result_2 = 2

class AoC
  attr_reader :input

  def initialize(input)
    @input = input.map { |el| el.split(' ').map(&:strip).map(&:to_i) }
  end

  def run_part_1!
    input.map do |history|
      extrapolate_last(history)
    end.sum
  end

  def run_part_2!
    input.map do |history|
      extrapolate_first(history)
    end.sum
  end

  private

  def extrapolate_last(arr)
    hist_array = reduce_history(arr)

    hist_array.last << 0
    (0..(hist_array.length - 2)).map { |el| el }.reverse.each do |i|
      hist_array[i] << hist_array[i].last + hist_array[i+1].last
    end
    hist_array.first.last
  end

  def extrapolate_first(arr)
    hist_array = reduce_history(arr)

    hist_array.last.unshift 0
    (0..(hist_array.length - 2)).map { |el| el }.reverse.each do |i|
      hist_array[i].unshift(hist_array[i].first - hist_array[i+1].first)
    end
    hist_array.first.first
  end

  def reduce_history(arr)
    hist_array = [arr]
    begin
      arr = (1..arr.length - 1).map { |i| arr[i] - arr[i - 1] }
      hist_array << arr
    end while !arr.all?(&:zero?)

    hist_array
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
