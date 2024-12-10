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
  use input <- result.map(utils.read_input("input.txt"))

  input
  |> string.split("\n")
  |> parse_lines
  |> list.count(is_line_safe)
}

fn part2() {
  use input <- result.map(utils.read_input("input.txt"))

  input
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
  let windows = line |> list.window_by_2

  list.all(windows, fn(w) { w.0 - w.1 >= 1 && w.0 - w.1 <= 3 })
  || list.all(windows, fn(w) { w.1 - w.0 >= 1 && w.1 - w.0 <= 3 })
}

fn is_line_safe_with_tolerance(line) {
  list.combinations(line, list.length(line) - 1)
  |> list.any(is_line_safe)
}
