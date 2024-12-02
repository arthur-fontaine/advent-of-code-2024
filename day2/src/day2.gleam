import argv
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utils

pub fn main() {
  case argv.load().arguments {
    ["part1"] -> part1() |> io.debug |> utils.void
    ["part2"] -> part2() |> io.debug |> utils.void
    _ -> io.println("Please provide a part to run: part1")
  }
}

fn part1() {
  utils.read_input("input.txt")
  |> string.split("\n")
  |> parse_lines
  |> list.count(is_line_safe)
}

fn part2() {
  utils.read_input("input.txt")
  |> string.split("\n")
  |> parse_lines
  |> list.count(is_line_safe_with_tolerance)
}

fn parse_lines(lines) {
  use x <- list.map(lines)

  x
  |> string.split(" ")
  |> list.map(int.parse)
  |> result.values
}

fn is_line_safe(line) {
  is_all_line_diffs_ok(line) && is_all_line_same_direction(line)
}

fn is_all_line_diffs_ok(line) {
  let diffs = get_line_diffs(line, [])
  use x <- list.all(diffs)
  int.absolute_value(x) <= 3 && int.absolute_value(x) >= 1
}

fn is_all_line_same_direction(line) {
  let diffs = get_line_diffs(line, [])
  list.all(diffs, fn(x) { x > 0 }) || list.all(diffs, fn(x) { x < 0 })
}

fn get_line_diffs(line, result) {
  case line {
    [first, second, ..rest] -> {
      let diff = second - first
      get_line_diffs([second, ..rest], [diff, ..result])
    }
    _ -> result
  }
}

fn is_line_safe_with_tolerance(line) {
  let possibilities = get_line_possibilities(line)
  list.any(possibilities, is_line_safe)
}

fn get_line_possibilities(line) {
  use _, i <- list.index_map(line)

  line
  |> list.index_fold([], fn(r, x, j) {
    case j == i {
      True -> r
      False -> [x, ..list.reverse(r)] |> list.reverse
    }
  })
}
