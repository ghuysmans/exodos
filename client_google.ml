open Lwt.Infix
open Google_j

let path retro src dst time = Lwt_main.run (
  let open Google in
  let p =
    if retro then
      path_retro src dst time
    else
      path src dst time
  in
  p |> get_one >>= fun {legs; summary; _} ->
  legs |> Lwt_list.iter_s (fun l ->
    Lwt_io.printf "%s -> %s, %s, %s, %d steps\n"
      l.departure_time.text
      l.arrival_time.text
      l.distance.text
      l.duration.text
      (List.length l.steps) >>= fun () ->
    l.steps |> Lwt_list.iter_s (fun s ->
      Lwt_io.printf "- %s, %s\n" s.html_instructions s.duration.text
    )
  )
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
  let doc = "find a path between two places" in
  Term.(const path $ retro $ src $ dst $ time_opt),
  Term.info "path" ~doc

let () =
  Term.(exit @@ eval @@ path_cmd)
