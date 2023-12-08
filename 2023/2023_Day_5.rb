require 'pry'

test_input = File.readlines('2023_Day_5_test_input.txt').map(&:strip)
test_result = 35

class AoC
  attr_reader :input

  MAPS = %w[
    seed-to-soil
    soil-to-fertilizer
    fertilizer-to-water
    water-to-light
    light-to-temperature
    temperature-to-humidity
    humidity-to-location
  ]

  def initialize(input)
    @input = input + ['']
  end

  def run_part_1!
    seeds = fetch_seeds
    seeds.map do |seed|
      location_for_seed(seed)
    end.min
  end

  def run_part_2!
    new_seeds = seed_table
    MAPS.each do |map|
      new_seeds = process_mapping_for_part_2(map, new_seeds)
    end
    new_seeds.first[:start]
  end

  private

  def fetch_seeds
    input.first.gsub('seeds: ', '').split(' ').map(&:to_i)
  end

  def location_for_seed(seed)
    soil = process_mapping(mappings['seed-to-soil'], seed)
    fertilizer = process_mapping(mappings['soil-to-fertilizer'], soil)
    water = process_mapping(mappings['fertilizer-to-water'], fertilizer)
    light = process_mapping(mappings['water-to-light'], water)
    temperature = process_mapping(mappings['light-to-temperature'], light)
    humidity = process_mapping(mappings['temperature-to-humidity'], temperature)
    process_mapping(mappings['humidity-to-location'], humidity)
  end

  def mappings 
    @mappings ||= begin
      m = {}
      MAPS.each do |name|
        m.merge!("#{name}" => fetch_mapping(name))
      end
      m
    end
  end

  def process_mapping(mapping, value)
    ret = value
    mapping.each do |m|
      (dest, src, count) = m.split(' ').map(&:to_i)

      if value >= src && value <= (src + count - 1)
        ret = value + (dest - src)
      end
    end
    ret
  end

  def seed_table
    @seed_table ||= begin
      seeds = input.first.gsub('seeds: ', '').split(' ').map(&:to_i)
      seed_map = []
      begin
        start = seeds.shift
        count = seeds.shift
        seed_map << {
          start: start,
          end: start + count - 1
        }
      end while seeds.any?
      seed_map.sort_by { |s| s[:start] }
    end
  end

  def process_mapping_for_part_2(name, seeds)
    max_seed = seeds.last[:end]
    min_seed = seeds.first[:start]
    mapping = fetch_mapping(name)
    mo = mapping.map do |map|
      m = map.split(' ').map(&:to_i)
      {
        start: m[1],
        end: m[1] + m[2] - 1,
        offset: m[0] - m[1]
      }
    end.sort_by { |s| s[:start] }

    if mo.last[:end] < max_seed
      mo << {
        start: mo.last[:end] + 1,
        end: max_seed,
        offset: 0
      }
    end

    if mo.first[:start] > min_seed
      mo_end = mo.first[:start] - 1
      mo.unshift({
        start: 0,
        end: mo_end,
        offset: 0
      })
    end

    (0..mo.length - 2).each do |i|
      unless mo[i+1][:start] - mo[i][:end] == 1
        mo << { start: mo[i][:end] + 1, end: mo[i+1][:start] - 1, offset: 0 }
      end
    end

    mo.sort_by! { |s| s[:start] }
    mo.reject! { |m| m[:end] < min_seed }
    mo.reject! { |m| m[:start] > max_seed }

    new_seeds = []
    begin
      s = seeds.first
      if mo.select { |m| m[:start] <= s[:start] && m[:end] >= s[:end] }.any?
        new_seeds << seeds.shift
      else
        mmo = mo.find { |el| el[:start] <= s[:start] && el[:end] >= s[:start] }
        s = seeds.shift
        seeds.unshift({ start: s[:start], end: mmo[:end] })
        seeds.unshift({ start: mmo[:end] + 1, end: s[:end] })
      end
    end while seeds.any?
    
    ns = new_seeds.map do |s|
      m = mo.find { |m| m[:start] <= s[:start] && m[:end] >= s[:end] }
      offset = m[:offset]
      {
        start: s[:start] + offset,
        end: s[:end] + offset
      }
    end.sort_by { |s| s[:start] }

    (0..ns.length - 2).each do |i|
      if ns[i][:end] + 1 == ns[i+1][:start]
        ns[i+1][:start] = ns[i][:start]
        ns[i][:start] = ns[i][:end] = 0
      end
    end
    ns.reject { |s| s[:start] == 0 && s[:end] == 0 }
  end

  def fetch_mapping(name)
    begin
      line = input.shift  
    end while !line.match /#{name}/

    arr = []
    begin
      line = input.shift  
      arr << line unless line == ''
    end while line != ''

    arr
  end
end

if ENV['SHOW_TEST']&.downcase == 'y'
  result = AoC.new(test_input).run_part_1!
  puts "Expected result: #{test_result}, actual: #{result.inspect}"
end

input = File.readlines('2023_Day_5_input.txt').map(&:strip)
result = AoC.new(input).run_part_1!

puts 'Advent Of Code 2023 - Day 5 Part 1'
puts "Result: #{result}"

# # Part 2:
test_result = 46

if ENV['SHOW_TEST']&.downcase == 'y'
  result = AoC.new(test_input).run_part_2!
  puts "Expected result: #{test_result}, actual: #{result}"
end

input = File.readlines('2023_Day_5_input.txt').map(&:strip)
result = AoC.new(input).run_part_2!

puts 'Advent Of Code 2023 - Day 5 Part 2'
puts "Result: #{result}"

