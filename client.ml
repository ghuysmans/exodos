open Lwt.Infix
open Routeserver_j

let path retro src dst time = Lwt_main.run (
  let open Routeserver in
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
  p >|= dump
)


open Cmdliner

let src =
  let doc = "start point" in
  Arg.(required & pos 0 (some Point.conv) None & info ~doc ~docv:"start" [])

let dst =
  let doc = "end point" in
  Arg.(required & pos 1 (some Point.conv) None & info ~doc ~docv:"end" [])

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
