open Routeserver_j

let default_to d = function
  | Some x -> x
  | None -> d

let to_string_o = Option.map (fun t ->
  CalendarLib.Calendar.(Printf.sprintf "%02d:%02d" (hour t) (minute t))
)


let dump_narrative =
  let d t = Calendar.(of_json_o t |> to_string_o) |> default_to "?" in
  List.iter (function
    | `BoardEvent {when_; what; _} ->
      Printf.printf "%s\t%s\n" (d when_) what
    | `DescribeCrossingAtAlightEvent _ -> ()
    | `AlightEvent {when_; what; _} ->
      Printf.printf "%s\t%s\n" (d when_) what
  )

let () =
  print_endline "path:";
  let p = Ag_util.Json.from_file read_path "path" in
  p.narrative |> dump_narrative;
  print_endline "retro:";
  let p = Ag_util.Json.from_file read_path_retro "path_retro" in
  p |> dump_narrative;
