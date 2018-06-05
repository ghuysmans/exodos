open Lwt.Infix
open Routeserver_j

let default_to d = function
  | Some x -> x
  | None -> d

let string_of_cal_o = Option.map (fun t ->
  CalendarLib.Calendar.(Printf.sprintf "%02d:%02d" (hour t) (minute t))
)

let dump_narrative =
  let d t = Calendar.(of_json_o t |> string_of_cal_o) |> default_to "?" in
  Lwt_list.iter_s (function
    | `BoardEvent {when_; what; _} ->
      Lwt_io.printf "%s\t%s\n" (d when_) what
    | `DescribeCrossingAtAlightEvent _ -> Lwt.return_unit
    | `AlightEvent {when_; what; _} ->
      Lwt_io.printf "%s\t%s\n" (d when_) what
  )

let path retro src dst time = Lwt_main.run (
  let open Routeserver in
  let src = point_of_stop src in
  let dst = point_of_stop dst in
  let time = CalendarLib.Calendar.from_unixfloat time in
  (if retro then
    path_retro src dst time
  else
    path src dst time >|= fun p -> p.narrative
  ) >|= dump_narrative
)

open Cmdliner

let src =
  let doc = "start stop (prefix)" in
  Arg.(required & pos 0 (some string) None & info ~doc ~docv:"start" [])

let dst =
  let doc = "end stop (prefix)" in
  Arg.(required & pos 1 (some string) None & info ~doc ~docv:"end" [])

let retro =
  let doc = "time is the arrival time" in
  Arg.(value & flag & info ~doc ["r"; "retro"])

let time =
  let doc = "time (default: now)" in
  Arg.(value & opt float (Unix.time ()) & info ~doc ["t"; "time"])

let path_cmd =
  let doc = "find a path between two stops" in
  Term.(const path $ retro $ src $ dst $ time),
  Term.info "path" ~doc

let () =
  Term.(exit @@ eval @@ path_cmd)
