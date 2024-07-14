import gleam/io
import gleam/string
import gleam/list
import gleam/result
import gleam/int

import simplifile



pub fn main() {
  case simplifile.read("input") {
    Ok(input) -> { 
      let areas = string.trim(input)
                  |> string.split("\n")
                  |> list.map(string.split(_, "x"))
                  |> list.map(surface_area)
                  |> result.all()

      case areas {
        Ok(areas) -> io.println(int.to_string(list.fold(areas, 0, int.add)))

        Error(err) -> io.println_error(err)
      }
    }


    Error(err) -> io.println_error(simplifile.describe_error(err))
  }
}


fn surface_area(dims: List(String)) -> Result(Int, String) {
  case dims {
    [length, width, height] -> {
      use l <- result.try(parse_dim(length, "length"))
      use w <- result.try(parse_dim(width, "width"))
      use h <- result.try(parse_dim(height, "height"))

      let smallest_area = case list.sort([l, w, h], by: int.compare) {
        [a, b, _] -> a * b
        _ -> 0
      }

      Ok(2*l*w + 2*w*h + 2*h*l + smallest_area)
    }

    _ -> Error("Invalid dim structure: " <> pretty_dim(dims))
  }
}


fn parse_dim(dim: String, dim_name: String) -> Result(Int, String) {
  dim
  |> int.base_parse(10)
  |> result.map_error(fn(_) { "Invalid " <> dim_name <> ": " <> dim })
}


fn pretty_dim(dims: List(String)) -> String {
  case dims {
    [d] -> d
    [d, ..ds] -> d <> "x" <> pretty_dim(ds)
    _ -> ""
  }
}
