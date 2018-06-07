open Lwt.Infix
open Routeserver_j

let default_to d = function
  | Some x -> x
  | None -> d

let dump_narrative =
  let d t = Calendar.(of_json_o t |> Option.map Time.to_string) |> default_to "?" in
  Lwt_list.iter_s (function
    | `BoardEvent {when_; what; _}
    | `StreetStartEvent {when_; what; _}
    | `StreetTurnEvent {when_; what; _}
    | `StreetEndEvent {when_; what; _} ->
      Lwt_io.printf "%s\t%s\n" (d when_) what
    | `AlightEvent {when_; where; geom = lat, lon; _} ->
      Lwt_io.printf "%s\talight at %s (%f, %f)\n" (d when_)
        (default_to "?" where)
        lat lon
    | `DescribeCrossingAtAlightEvent _ ->
      Lwt.return_unit
  )

let stops = lazy (Stops.of_file "stops.txt")

(* FIXME match ^ *)
let vertex_of_string s =
  let open Tyre in
  let re = route [
    (regex (Re.rg 'A' 'Z') --> fun _ ->
      Lazy.force stops >|= fun arr ->
      let s = Stops.find_by_prefix arr s in
      Routeserver.vertex_of_name s.Stops.stop_id);
    (float <&> char ',' *> (opt (char ' ')) *> float) --> fun (lat, lon) ->
      Routeserver.vertex_of_geo ~lat ~lon
  ] in
  match exec re s with
  | Ok x -> x
  | Error _ -> Lwt.fail_with "vertex_of_string"

let path retro src dst time = Lwt_main.run (
  let open Routeserver in
  vertex_of_string src >>= fun src ->
  vertex_of_string dst >>= fun dst ->
  let p =
    if retro then
      path_retro src dst time
    else
      path src dst time >|= fun p ->
      Printf.fprintf stderr "clean=%f, narr=%f, query=%f\n"
        p.performance.cleanup_time
        p.performance.narrative_postprocess_time
        p.performance.path_query_time;
      p.narrative
  in
  p >|= dump_narrative
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

let time_opt =
  let doc = "time (default: now)" in
  Arg.(value & opt (some Time.conv) None & info ~doc ["t"; "time"])

let path_cmd =
  let doc = "find a path between two stops" in
  Term.(const path $ retro $ src $ dst $ time_opt),
  Term.info "path" ~doc

let () =
  Term.(exit @@ eval @@ path_cmd)
