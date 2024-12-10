import argv
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/yielder
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
  |> utils.iterate_lines
  |> get_columns
  |> sort_columns
  |> calculate_column_distances
  |> utils.sum_int_list
}

fn part2() {
  utils.read_input("input.txt")
  |> utils.iterate_lines
  |> get_columns
  |> get_similarity_score
}

pub type Columns {
  Columns(column_a: List(Int), column_b: List(Int), result: List(Int))
}

fn get_columns(lines) {
  lines
  |> yielder.fold(Columns([], [], []), fn(columns, line) {
    case string.split(line, "   ") {
      [a, b] -> {
        let a_int = int.parse(a) |> result.unwrap(-1)
        let b_int = int.parse(b) |> result.unwrap(-1)
        Columns([a_int, ..columns.column_a], [b_int, ..columns.column_b], [])
      }
      _ -> columns
    }
  })
}

fn sort_columns(columns: Columns) {
  Columns(
    list.sort(columns.column_a, int.compare),
    list.sort(columns.column_b, int.compare),
    list.sort(columns.result, int.compare),
  )
}

fn calculate_column_distances(columns: Columns) -> List(Int) {
  case columns.column_a {
    [a_value, ..rest_column_a] -> {
      case columns.column_b {
        [b_value, ..rest_column_b] -> {
          calculate_column_distances(
            Columns(rest_column_a, rest_column_b, [
              int.absolute_value(b_value - a_value),
              ..columns.result
            ]),
          )
        }
        _ -> columns.result
      }
    }
    _ -> columns.result
  }
}

fn get_similarity_score(columns: Columns) -> Int {
  columns.column_a
  |> list.fold(0, fn(total, a_value) {
    total + a_value * list.count(columns.column_b, fn(b) { b == a_value })
  })
}
