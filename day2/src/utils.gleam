import gleam/result
import gleam/string
import simplifile

pub fn read_input(path) {
  use file <- result.map(simplifile.read(path))

  file
  |> string.trim
}

pub fn void(_) {
  Nil
}
