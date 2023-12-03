input = File.read('2015_Day_3_input.txt')
# input = '^v^v^v^v^v'

visited = { '0_0' => 1 }
x = 0
y = 0
coords = "#{x}_#{y}"
puts "0: [S], X = #{x}, Y = #{y}, visited: #{coords}, times: #{visited[coords]}"
input.strip.split('').each_with_index do |char, i|
  case char
  when '>'
    x += 1
  when '<'
    x -= 1
  when '^'
    y += 1
  when 'v'
    y -= 1
  end
  coords = "#{x}_#{y}"
  if visited[coords].nil?
    visited[coords] = 1 
  else
    visited[coords] += 1
  end
  puts "#{i + 1}: [#{char}], X = #{x}, Y = #{y}, visited: #{coords}, times: #{visited[coords]}"
end
puts input.length
puts visited.length
puts visited.select { |el, v| v > 1 }.length
