require "big"

module Day7
  _input = read_input()
  input = parse_input _input

  result = input.reduce(0) do |acc, test_case|
    working = generate_operators(test_case[1], ARGV[0] == "part2").find do |operators|
      run_operations(test_case[1], operators) == test_case[0]
    end
    if working.nil?
      acc
    else
      acc + run_operations(test_case[1], working)
    end
  end
  puts result
end

def read_input : String
  File.read("input.txt").strip
end

def parse_input(input : String)
  input.split("\n").map do |line|
    parse_line line
  end
end

def parse_line(line : String)
  parts = line.split(": ")
  test_value = parts[0].to_i128
  ns = parts[1].split(" ").map do |part|
    part.to_i
  end
  {test_value, ns}
end

def generate_operators(n : Array(Int32), with_concat = false)
  max = n.size - 1

  operators = [] of Char
  (0...max).each do
    operators << '+'
  end

  result = [operators]
  _generate_operators(operators, 0, result, with_concat)
  result
end

def _generate_operators(curr_operators, min_i_replacement, result, with_concat)
  Array(Array(Char))
  if min_i_replacement < curr_operators.size
    (min_i_replacement..(curr_operators.size - 1)).flat_map do |i|
      new_operators_times = curr_operators.dup
      new_operators_times[i] = '*'
      result << new_operators_times
      _generate_operators(new_operators_times, i + 1, result, with_concat)

      if !with_concat
        next
      end

      new_operators_concat = curr_operators.dup
      new_operators_concat[i] = '|'
      result << new_operators_concat
      _generate_operators(new_operators_concat, i + 1, result, with_concat)
    end
  end
end

def flatten_once(arr)
  arr.flat_map do |sub_arr|
    sub_arr
  end
end

def filter_duplicated_operators(operators : Array(Array(Char)))
  operators.uniq
end

def run_operations(n : Array(Int32), operators : Array(Char))
  result = n[0].to_big_i
  n[1..].each_with_index do |number, i|
    operator = operators[i]
    if operator == '+'
      result += number
    else
      if operator == '*'
        result *= number
      else
        result = "#{result}#{number}".to_big_i
      end
    end
  end
  result
end
