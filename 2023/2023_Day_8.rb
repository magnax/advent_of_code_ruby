require 'pry'

DAY = '8'

test_input = File.readlines("2023_Day_#{DAY}_test_input.txt").map(&:strip)
input =      File.readlines("2023_Day_#{DAY}_input.txt").map(&:strip)

test_result_1 = 6
test_result_2 = nil

class AoC
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def run_part_1!
    dist = 0
    key = :AAA
    begin
      sequence.each do |dir|
        key = steps[key][dir]
        dist += 1
        return dist if key == :ZZZ
      end
    end while key != :ZZZ
  end

  def run_part_2!
    dist = 0
    keys = steps.keys.select { |s| s.match /..A/ }
    nk = keys.map do |key|
      run_sequence(key)
    end
    # use built-in ruby function for finding LCM (Least Common Multiple)
    # because it takes 2 parameters we recursively reduce it over array of numbers 
    nk.reduce(&:lcm)
  end

  private

  def run_sequence(key)
    dist = 0
    begin
      sequence.each do |dir|
        key = steps[key][dir]
        dist += 1
        return dist if key.match /..Z/
      end
    end while !key.match /..Z/
    dist
  end

  def sequence
    @sequence ||= input.first.split('').map(&:downcase).map(&:to_sym)
  end

  def steps
    @steps ||= input.slice(2, 9999).reduce({}) do |sh, s|
      (key, l_r) = s.split('=').map(&:strip)
      l_r_array = l_r.tr('()', '').split(',').map(&:strip).map(&:to_sym)
      sh.merge!("#{key}": { l: l_r_array.first, r: l_r_array.last })
    end
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
