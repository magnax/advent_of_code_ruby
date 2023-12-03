module AdventOfCode2023
  SPELLED_DIGITS = %w[zero one two three four five six seven eight nine]
  DIGITS = [
    { '1' => 1 },
    { '2' => 2 },
    { '3' => 3 },
    { '4' => 4 },
    { '5' => 5 },
    { '6' => 6 },
    { '7' => 7 },
    { '8' => 8 },
    { '9' => 9 },
    { 'one' => 1 },
    { 'two' => 2 },
    { 'three' => 3 },
    { 'four' => 4 },
    { 'five' => 5 },
    { 'six' => 6 },
    { 'seven' => 7 },
    { 'eight' => 8 },
    { 'nine' => 9 }
  ]

  def self.number_from_string(string)
    m = string.gsub /\D/, ''
    [m[0], m[m.length - 1]].join('')
  end

  def self.better_number_from_string(string)
    found = []
    (0..string.length - 1).each do |i|
      DIGITS.each do |k|
        if string.slice(i, 999).index(k.keys.first) == 0
          found << k[k.keys.first]
        end
      end
    end
    [found.first, found.last].join('').to_i
  end
end

# Part 1:
result = 
  File.readlines('2023_Day_1a_input.txt')
    .map(&:strip)
    .map { |s| AdventOfCode2023.number_from_string(s) }
    .map(&:to_i)
    .sum

puts 'Advent Of Code 2023 - Day 1 Part 1'
puts "Result: #{result}"

test = [
  { 'two1nine' => 29 },
  { 'eightwothree' => 83 },
  { 'abcone2threexyz' => 13 },
  { 'xtwone3four' => 24 },
  { '4nineeightseven2' => 42 },
  { 'zoneight234' => 14 },
  { '7pqrstsixteen' => 76 },
  { '7ljbdfour1tnfive81' => 71 },
  { '1four2eightseven8one3eightwogrr' => 12 },
  { '843trvvsxdkfspsixonethreeone' => 81 },
  { '7bbxlhgdbrh9sph44sbboneoneightxcn' => 78 },
]

if ENV['SHOW_TEST']&.downcase == 'y'
  test.each do |t|
    r = AdventOfCode2023.better_number_from_string(t.keys.first).to_i
    puts "#{t.keys.first} is #{r} and should be #{t.values.first}"
  end

  puts
end

# Part 2:
result = 
  File.readlines('2023_Day_1a_input.txt')
    .map(&:strip)
    .map { |s| AdventOfCode2023.better_number_from_string(s) }
    .map(&:to_i)
    .sum

puts 'Advent Of Code 2023 - Day 1 Part 2'
puts "Result: #{result}"
