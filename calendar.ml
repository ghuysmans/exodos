(* FIXME handle time zones? *)

type t = CalendarLib.Calendar.t

let fmt = Tyre.(
  start *>
  int <&> char '-' *> int <&> char '-' *> int <&> char ' ' *>
  int <&> char ':' *> int <&> char ':' *> int <&> (char '-' <|> char '+') <&>
  int <&> char ':' *> int
  <* stop
)

let wrap s =
  match Tyre.(exec (compile fmt) s) with
  | Ok ((((((((year, month), day), hour), minute), second), d), th), tm) ->
    CalendarLib.Calendar.lmake ~year ~month ~day ~hour ~minute ~second ()
  | Error _ -> failwith "Calendar.of_string"

let unwrap t =
  Tyre.eval fmt CalendarLib.Calendar.((((((((
    year t, CalendarLib.Date.int_of_month (month t)), day_of_month t),
    hour t), minute t), second t),
    `Right ()), 0), 0)
