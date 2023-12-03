require 'pry'

def find_symbols(input_lines)
  input_lines.map do |line|
    line.strip.tr('.', '').gsub(/\d/, '').split('')
  end.flatten.reject { |e| e == '' }.uniq
end

def find_gears(input_lines)
  addr = []
  input_lines.each_with_index do |line, y|
    line.split('').each_with_index do |char, x|
      addr << [x, y] if char == '*'
    end
  end
  addr
end

def find_gear_ratios(input, gears)
  ratio = 0
  gears.each do |gear|
    slice = [
      input[gear[1]-1].slice(gear[0]-1,3),
      input[gear[1]].slice(gear[0]-1,3),
      input[gear[1]+1].slice(gear[0]-1,3)
    ]
    next unless slice.any? { |s| s.match /\d/ }

    upper_line = find_gear_numbers(input[gear[1] - 1], gear[0])
    middle_line = find_gear_numbers(input[gear[1]], gear[0])
    down_line = find_gear_numbers(input[gear[1] + 1], gear[0])

    flatten_lines = [upper_line, middle_line, down_line].flatten
    next unless flatten_lines.length == 2

    ratio += flatten_lines.map(&:to_i).reduce(1) { |el, acc| el * acc }
  end
  ratio
end

def find_gear_numbers(string, index)
    i = index
    numbers = []
    string = "#{string}."
    area = string.slice(index - 1, 3)
    if area.match /\d\D\D/ # one number in left direction
      num = []
      begin
        i -= 1
        num << [string[i]]
      end while string[i - 1].match /\d/
      numbers << num.reverse.join('')
    elsif area.match /\d\D\d/ # two numbers - one left and one right above/below
      # go left
      num = []
      begin
        i -= 1
        num << [string[i]]
      end while string[i - 1].match /\d/
      numbers << num.reverse.join('')
      # go right
      num = []
      i = index
      begin
        i += 1
        num << [string[i]]
      end while string[i + 1].match /\d/
      numbers << num.join('')
    elsif area.match /\D\D\d/ # one number in right direction
      num = []
      begin
        i += 1
        num << [string[i]]
      end while string[i + 1].match /\d/
      numbers << num.join('')      
    elsif area.match /\D\d\d/ # one number in right direction
      num = []
      begin
        num << [string[i]]
        i += 1
      end while string[i].match /\d/
      numbers << num.join('')
    elsif area.match /\d\d\D/ # one number in left direction starting middle
      num = []
      begin
        num << [string[i]]
        i -= 1
      end while string[i].match /\d/
      numbers << num.reverse.join('')
    elsif area.match /\d\d\d/ # one number above/below
      num = []
      begin
        i -= 1
      end while string[i - 1].match /\d/
      begin
        num << [string[i]]
        i += 1
      end while string[i].match /\d/
      numbers << num.join('')
    end
    numbers
end

def find_symbol_addresses(input_lines, symbols)
  addr = []
  input_lines.each_with_index do |line, y|
    line.split('').each_with_index do |char, x|
      addr << [x, y] if symbols.include?(char)
    end
  end
  addr
end

def find_numbers(input_lines, symbols, addresses)
  numbers = []
  input_lines.each_with_index do |line, y|
    current_number = {}
    (line.split('') + ['.']).each_with_index do |char, x|
      if char.match /\d/
        if current_number == {}
          current_number = { y: y, x1: x, x2: x, n: char }
        else
          current_number[:x2] = x
          current_number[:n] = current_number[:n] + char
        end
      else
        if current_number != {}
          filtered_addresses =
            addresses
              .select { |ax,ay| (y-1..y+1).include? ay }
              .select { |ax,ay| (current_number[:x1]-1..current_number[:x2]+1).include? ax }
          if filtered_addresses.any?
            numbers << current_number[:n].to_i
          end
        end
        current_number = {}
      end
    end
  end
  numbers.sum
end

test = "467..114..
...*......
..35...633
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."

test_result = 4361

def process(input)
  symbols = find_symbols(input)
  addresses = find_symbol_addresses(input, symbols)
  find_numbers(input, symbols, addresses)
end

if ENV['SHOW_TEST']&.downcase == 'y'
  result = process(test.split("\n"))
  puts "Expected result: #{test_result}, actual: #{result.inspect}"
end

input = File.readlines('2023_Day_3_input.txt').map(&:strip)
result = process(input)

puts 'Advent Of Code 2023 - Day 3 Part 1'
puts "Result: #{result.inspect}"

# Part 2:
test_result = 467835

def process2(input)
  gears = find_gears(input)
  find_gear_ratios(input, gears)
end

if ENV['SHOW_TEST']&.downcase == 'y'
  result = process2(test.split("\n"))
  puts "Expected result: #{test_result}, actual: #{result}"
end

input = File.readlines('2023_Day_3_input.txt').map(&:strip)
result = process2(input)

puts 'Advent Of Code 2023 - Day 3 Part 3'
puts "Result: #{result}"

