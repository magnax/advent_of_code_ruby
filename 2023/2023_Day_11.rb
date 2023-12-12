require 'pry'

DAY = '11'

test_input = File.readlines("2023_Day_#{DAY}_test_input.txt").map(&:strip)
input =      File.readlines("2023_Day_#{DAY}_input.txt").map(&:strip)

test_result_1 = 374

# for expand rate of 10
# test_result_2 = 1030

# for expand rate of 100
test_result_2 = 8410

class AoC
  attr_reader :input

  EXPAND_RATE = 1_000_000

  def initialize(input)
    @input = input
  end

  def run_part_1!
    new_input = expand
    coords = identify_pairs(new_input)
    calculate_paths(new_input, coords)
  end

  def run_part_2!
    expanded_columns = (0..input.first.length - 1).map do |i|
      i if column(i).uniq == ['.']
    end.compact

    expanded_rows = input.map.with_index do |line, i|
      if !line.index('#')
        i
      end
    end.compact

    coords = identify_pairs(input)
    calculate_paths_in_expanded_universe(input, expanded_columns, expanded_rows, coords)
  end

  private

  def calculate_paths(input, coords)
    distances = []
    (0..coords.length - 2).each do |i|
      (i + 1..coords.length - 1).each do |j|
        distances << distance(coords[i], coords[j])
      end
    end
    distances.sum
  end

  def calculate_paths_in_expanded_universe(input, expanded_columns, expanded_rows, coords)
    distances = []
    coords = transform_coords_for_expanded_universe(coords, expanded_columns, expanded_rows)

    (0..coords.length - 2).each do |i|
      (i + 1..coords.length - 1).each do |j|
        distances << distance(coords[i], coords[j])
      end
    end
    distances.sum
  end

  def transform_coords_for_expanded_universe(coords, expanded_columns, expanded_rows)
    coords.map do |coord|
      [
        expanded_columns.select { |c| c < coord[0] }.length * (EXPAND_RATE - 1) + coord[0],
        expanded_rows.select { |c| c < coord[1] }.length * (EXPAND_RATE - 1) + coord[1]
      ]
    end
  end

  def distance(a, b)
    (b[0] - a[0]).abs + (b[1] - a[1]).abs
  end

  def identify_pairs(input)
    coords = []
    input.each_with_index do |line, y|
      line.split('').each_with_index do |ch, x|
        coords << [x, y] if ch == '#'
      end
    end
    coords
  end

  def expand
    expanded_columns = (0..input.first.length - 1).map do |i|
      i if column(i).uniq == ['.']
    end.compact
    
    expanded_columns_input = input.map do |line|
      expanded_columns.each_with_index do |c, i|
        line = line.slice(0,c+i) + line[c+i]*2 + line.slice(c+i+1, 999)
      end
      line
    end

    expanded_rows_input = []
    expanded_columns_input.each do |line|
      if line.index('#')
        expanded_rows_input << line
      else
        expanded_rows_input << line
        expanded_rows_input << line
      end
    end

    expanded_rows_input
  end

  def column(i)
    input.map { |line| line[i] }
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
