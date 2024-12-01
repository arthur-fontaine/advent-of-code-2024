import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/yielder
import simplifile

pub fn main() {
  read_input("./src/input.txt")
  |> result.unwrap("")
  |> string.trim
  |> iterate_lines
  |> get_columns
  |> sort_columns
  |> calculate_column_distances
  |> sum_int_list
  |> io.debug
}

fn read_input(path) {
  simplifile.read(path)
}

fn iterate_lines(input) {
  string.split(input, "\n")
  |> yielder.from_list
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

fn sum_int_list(l) {
  l
  |> list.fold(0, fn(a, b) { a + b })
}
