import gleam/io
import gleam/string
import gleam/int
import simplifile


pub fn main() {
  case simplifile.read("input") {
    Ok(input) -> {
      case floor(input) {
        Ok(floor) -> io.println(int.to_string(floor))

        Error(err) -> io.println_error(err)
      }

      case basement_position(input) {
        Ok(pos) -> io.println(int.to_string(pos))

        Error(err) -> io.println_error(err)
      }
    }

    Error(err) -> {
      io.println(simplifile.describe_error(err))
    }
  }
}


fn floor(input: String) -> Result(Int, String) {
  floor_helper(string.trim(input), 0)
}


fn floor_helper(chars: String, acc: Int) -> Result(Int, String) {
  case string.pop_grapheme(chars) {
    Ok(#(c, cs)) -> {
      case c {
        "(" -> floor_helper(cs, acc + 1)
        ")" -> floor_helper(cs, acc - 1)
        c -> Error("Invalid character: " <> c)
      }
    }

    Error(_) -> Ok(acc)
  }
}


fn basement_position(input: String) -> Result(Int, String) {
  basement_position_helper(string.trim(input), 0, 1)
}


fn basement_position_helper(chars: String, current_floor: Int, current_position: Int) -> Result(Int, String) {
  case string.pop_grapheme(chars) {
    Ok(#(c, cs)) -> {
      case c {
        "(" -> basement_position_helper(cs, current_floor + 1, current_position + 1)
        ")" -> {
          let floor = current_floor - 1
          case floor {
            -1 -> Ok(current_position)
            _ -> basement_position_helper(cs, floor, current_position + 1)
          }
        }

        c -> Error("Invalid character: " <> c)
      }
    }

    Error(_) -> Error("Never reached basement")
  }
}
