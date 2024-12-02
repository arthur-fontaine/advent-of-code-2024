import gleam/result
import gleam/string
import simplifile

pub fn read_input(path) {
  simplifile.read(path)
  |> result.unwrap("")
  |> string.trim
}

pub fn void(_) {
  Nil
}
