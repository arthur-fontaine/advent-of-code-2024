import gleam/list
import gleam/string
import gleam/yielder
import simplifile

pub fn read_input(path) {
  simplifile.read(path)
}

pub fn iterate_lines(input) {
  string.split(input, "\n")
  |> yielder.from_list
}

pub fn sum_int_list(l) {
  l
  |> list.fold(0, fn(a, b) { a + b })
}

pub fn void(_) {
  Nil
}
