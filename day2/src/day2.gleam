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
    _ -> io.println("Please provide a part to run: part1")
  }
}

fn part1() {
  utils.read_input("input.txt")
  |> string.split("\n")
  |> parse_lines
  |> list.count(is_line_safe)
}

fn parse_lines(lines: List(String)) {
  use x <- list.map(lines)

  x
  |> string.split(" ")
  |> list.map(int.parse)
  |> result.values
}

fn is_line_safe(line: List(Int)) {
  is_all_line_diffs_ok(line) && is_all_line_same_direction(line)
}

fn is_all_line_diffs_ok(line: List(Int)) {
  let diffs = get_line_diffs(line, [])
  use x <- list.all(diffs)
  int.absolute_value(x) <= 3 && int.absolute_value(x) >= 1
}

fn is_all_line_same_direction(line: List(Int)) {
  let diffs = get_line_diffs(line, [])
  list.all(diffs, fn(x) { x > 0 }) || list.all(diffs, fn(x) { x < 0 })
}

fn get_line_diffs(line: List(Int), result: List(Int)) -> List(Int) {
  case line {
    [first, second, ..rest] -> {
      let diff = second - first
      get_line_diffs([second, ..rest], [diff, ..result])
    }
    _ -> result
  }
}
