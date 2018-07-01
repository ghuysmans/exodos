open Irail
open Irail_t
open Lwt.Infix

let () = Lwt_main.run (
  departures (Point.Address Sys.argv.(1)) >>=
  Lwt_list.iter_s @@ fun {delay; station; time; platform; canceled; _} ->
    let {sta_name; _} = station in
    let d =
      if delay = 0 then
        ""
      else
        Printf.sprintf "+%d" (delay / 60)
    in
    Lwt_io.printf "%s%s\t%s\n" (Time.to_string time) d sta_name
)
