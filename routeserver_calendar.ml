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
  | Ok ((((((((year, month), day), hour), minute), second), _), th), 0) ->
    let open CalendarLib in
    Calendar.lmake ~year ~month ~day ~hour ~minute ~second () |>
    Time_Zone.(on Calendar.to_gmt (UTC_Plus th))
  | _ -> failwith "Calendar.of_string"

let unwrap t =
  Tyre.eval fmt CalendarLib.(Calendar.(((((((
    year t, Date.int_of_month (month t)), day_of_month t),
    hour t), minute t), second t),
    `Right ()), 0), 0)
