require 'pry'

DAY = '10'

test_input = File.readlines("2023_Day_#{DAY}_test_input.txt").map(&:strip)
input =      File.readlines("2023_Day_#{DAY}_input.txt").map(&:strip)

test_result_1 = 8
test_result_2 = 46

class AoC
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def run_part_1!
    run_through_maze
  end

  def run_part_2!
    run_through_maze(true)
  end

  def run_through_maze(draw = false)
    maze_width = input.first.length
    maze_height = input.length
    (x, y) = find_start
    start_position = { x: x, y: y, char: 'S', from: nil }
    current_position = start_position
    maze = [current_position]
    total_dist = 0
    begin
      current_position = next_position(current_position)
      total_dist += 1
      if draw && current_position[:char] != 'S'
        maze << current_position
      end
    end while current_position[:char] != 'S'
    if draw
      draw_maze(maze)
    else
      total_dist / 2
    end
  end

  private

  def find_start
    y = find_line
    [input[y].index('S'), y]
  end

  def find_line
    input.each_with_index { |line, i| return i if line.match /.*S.*/ }
  end

  def next_position(pos)
    ch = chars_around(pos)
    if pos[:char] == 'S'
      return { x: pos[:x], y: pos[:y] - 1, char: ch[:up], from: :down } if %w[| 7 F].include?(ch[:up])
      return { x: pos[:x] + 1, y: pos[:y], char: ch[:right], from: :left } if %w[- J 7].include?(ch[:right])
      return { x: pos[:x], y: pos[:y] + 1, char: ch[:down], from: :up } if %w[| J L].include?(ch[:down])

      { x: pos[:x] - 1, y: pos[:y], char: ch[:left], from: :right }
    else
      ch.delete(pos[:from])
      case pos[:char]
      when 'J'
        return { x: pos[:x], y: pos[:y] - 1, char: ch[:up], from: :down } if ch[:up]
        
        { x: pos[:x] - 1, y: pos[:y], char: ch[:left], from: :right }
      when 'F'
        return { x: pos[:x] + 1, y: pos[:y], char: ch[:right], from: :left } if ch[:right]
        
        { x: pos[:x], y: pos[:y] + 1, char: ch[:down], from: :up }
      when '7'
        return { x: pos[:x] - 1, y: pos[:y], char: ch[:left], from: :right } if ch[:left]
        
        { x: pos[:x], y: pos[:y] + 1, char: ch[:down], from: :up }
      when '|'
        return { x: pos[:x], y: pos[:y] - 1, char: ch[:up], from: :down } if ch[:up]
        
        { x: pos[:x], y: pos[:y] + 1, char: ch[:down], from: :up }
      when 'L'
        return { x: pos[:x] + 1, y: pos[:y], char: ch[:right], from: :left } if ch[:right]
        
        { x: pos[:x], y: pos[:y] - 1, char: ch[:up], from: :down }
      when '-'
        return { x: pos[:x] + 1, y: pos[:y], char: ch[:right], from: :left } if ch[:right]
        
        { x: pos[:x] - 1, y: pos[:y], char: ch[:left], from: :right }
      end
    end
  end

  def chars_around(current_position)
    x = current_position[:x]
    y = current_position[:y]
    {
      up: y > 0 ? input[y-1][x] : nil,
      right: x < input[y].length ? input[y][x+1] : nil,
      down: y < (input.length - 1) ? input[y+1][x] : nil,
      left: x > 0 ? input[y][x-1] : nil
    }
  end

  def draw_maze(maze)
    f = File.open('day_10_maze_visualized.txt', 'w')
    maze_array = input.map do |line|
      '.'*line.length
    end

    maze.each do |m|
      maze_array[m[:y]][m[:x]] = m[:char]
    end

    maze_array.each do |line|
      f.write("#{line.tr('F7JL|-', '╭╮╯╰│─')}\n")
    end
    f.close

    inside_count = 0

    maze_array.each_with_index do |line, y|
      patterns = ''
      line.split('').each_with_index do |ch, x|
        # changing inside/outside patterns: | FJ L7 (last 2 may have horizontal segments inside) 
        case ch
        when '.'
          if !patterns.empty?
            lc = (patterns.scan /F-*J/).length + (patterns.scan /L-*7/).length + (patterns.scan /\|/).length
            if lc % 2 == 0
              maze_array[y][x] = '.'
            else
              maze_array[y][x] = 'o'
              inside_count += 1
            end
          end
        else
          patterns  = patterns + ch
        end
      end
    end

    f = File.open('day_10_maze_visualized_with_inside.txt', 'w')
    maze_array.each_with_index do |line, i|
      ii = "  #{i}".slice(-3, 3)
      f.write("#{ii} #{line.tr('F7JL|-', '╭╮╯╰│─')}\n")
    end
    f.close

    inside_count
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
