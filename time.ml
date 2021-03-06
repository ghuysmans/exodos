open CalendarLib

type t = Calendar.t

let to_string t =
  let t = Time_Zone.(on Calendar.from_gmt Local t) in
  Calendar.(Printf.sprintf "%02d:%02d" (hour t) (minute t))

let conv =
  let of_string s =
    let re = Tyre.(compile (start *> int <&> char ':' *> int <* stop)) in
    match Tyre.exec re s with
    | Ok (h, m) ->
      Ok (Calendar.create (Date.today ()) (Time.make h m 0) |>
          Time_Zone.(on Calendar.to_gmt Local))
    | Error _ ->
      Error (`Msg "invalid time (expected hh:mm)")
  in
  let print fmt t = Format.fprintf fmt "%s" (to_string t) in
  Cmdliner.Arg.conv ~docv:"time (hh:mm)" (of_string, print)
