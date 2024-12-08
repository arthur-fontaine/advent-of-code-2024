module Day8
  _input = read_input()
  antenna_types = get_antenna_types _input

  result = [] of {Int32, Int32}
  antenna_types.each do |antenna_type|
    antenna_combinations = get_antenna_combinations(_input, antenna_type)
    antenna_combinations.each do |antenna_combination|
      get_antinode_positions_from_pair_of_antenna(_input, antenna_combination).each { |antinode_position| result << antinode_position }
    end
  end

  puts "Result: #{result.uniq.size}"
end

def read_input : String
  File.read("input.txt").strip
end

def get_antenna_types(input : String) : Array(Char)
  input.each_char.select { |c| c != '\n' && c != '.' }.to_a.uniq
end

def get_antenna_combinations(input : String, char : Char)
  get_all_indexes(input, char).combinations(2).map { |c| {c[0], c[1]} }
end

def get_all_indexes(input : String, char : Char) : Array(Int32)
  r = [] of Int32
  i = 0
  while i < input.size
    if input[i] == char
      r << i
    end
    i += 1
  end
  r
end

def get_antinode_positions_from_pair_of_antenna(input : String, antenna_indexes : {Int32, Int32}) : Array({Int32, Int32})
  row_size = input.index('\n').not_nil!
  number_of_rows = input.size // row_size

  antenna1_position = get_antenna_position(input, antenna_indexes[0])
  antenna2_position = get_antenna_position(input, antenna_indexes[1])

  antinode1_position = {antenna1_position[0] - (antenna2_position[0] - antenna1_position[0]), antenna1_position[1] - (antenna2_position[1] - antenna1_position[1])}
  antinode2_position = {antenna2_position[0] - (antenna1_position[0] - antenna2_position[0]), antenna2_position[1] - (antenna1_position[1] - antenna2_position[1])}

  r = [get_antenna_position(input, antenna_indexes[0]), get_antenna_position(input, antenna_indexes[1])]
  while antinode1_position[0] >= 0 && antinode1_position[0] < number_of_rows && antinode1_position[1] >= 0 && antinode1_position[1] < row_size
    r << antinode1_position
    antinode1_position = {antinode1_position[0] - (antenna2_position[0] - antenna1_position[0]), antinode1_position[1] - (antenna2_position[1] - antenna1_position[1])}
  end
  while antinode2_position[0] >= 0 && antinode2_position[0] < number_of_rows && antinode2_position[1] >= 0 && antinode2_position[1] < row_size
    r << antinode2_position
    antinode2_position = {antinode2_position[0] - (antenna1_position[0] - antenna2_position[0]), antinode2_position[1] - (antenna1_position[1] - antenna2_position[1])}
  end

  r
end

def get_antenna_position(input : String, index : Int32)
  row_size = input.index('\n').not_nil!

  number_of_breakline = input[0..index].count('\n')
  real_index = index - number_of_breakline

  {real_index // row_size, real_index % row_size}
end

def get_antenna_index(input : String, position : {Int32, Int32})
  row_size = input.index('\n').not_nil!

  position[0] * row_size + position[1]
end
