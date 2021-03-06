type t = CalendarLib.Calendar.t

let fmt = Tyre.(
  start *>
  int <&> char '-' *> int <&> char '-' *> int <&> char 'T' *>
  int <&> char ':' *> int <&> char ':' *> int
  <* stop
)

let wrap s =
  match Tyre.(exec (compile fmt) s) with
  | Ok (((((year, month), day), hour), minute), second) ->
    CalendarLib.Calendar.lmake ~year ~month ~day ~hour ~minute ~second ()
  | Error _ -> failwith "Stib_calendar.of_json"

let unwrap t =
  Tyre.eval fmt CalendarLib.Calendar.(((((
    year t, CalendarLib.Date.int_of_month (month t)), day_of_month t),
    hour t), minute t), second t)
