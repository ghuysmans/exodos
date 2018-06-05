(* FIXME handle time zones? *)

type t = CalendarLib.Calendar.t

let fmt = Tyre.(
  int <&> char '-' *> int <&> char '-' *> int <&> char ' ' *>
  int <&> char ':' *> int <&> char ':' *> int <&> (char '-' <|> char '+') <&>
  int <&> char ':' *> int
)

let of_json s =
  match Tyre.(exec (compile fmt) s) with
  | Ok ((((((((year, month), day), hour), minute), second), d), th), tm) ->
    CalendarLib.Calendar.lmake ~year ~month ~day ~hour ~minute ~second ()
  | Error _ -> failwith "Calendar.of_string"

let to_json t =
  Tyre.eval fmt CalendarLib.Calendar.((((((((
    year t, CalendarLib.Date.int_of_month (month t)), day_of_month t),
    hour t), minute t), second t),
    `Right ()), 0), 0)


let of_json_o = Option.map of_json
let to_json_o = Option.map to_json
