open Lwt.Infix

let prot = ref "http"
let port = ref 8080
let host = ref "127.0.0.1"

let get endpoint p =
  Http.call ~scheme:!prot ~host:!host ~port:!port `GET endpoint p

(*
let stops = lazy (Stops.of_file "stops.txt")
*)

let place_of_point = Point.(function
  | Address a ->
    (*
    Lazy.force stops >|= fun arr ->
    let s = Stops.find_by_prefix arr a in
    s.Stops.stop_id
    *)
    failwith "FIXME"
  | GPS {lat; lng} ->
    let sof = Printf.sprintf "%f" in
    get "get_vertex_id" ["lat", [sof lat]; "lon", [sof lng]] >|=
    Ag_util.Json.from_string Routeserver_j.read_vertex_id
  | Place p ->
    Lwt.return p
)

let params origin dest time =
  let t =
    match time with
    | None -> CalendarLib.Calendar.now ()
    | Some t -> t
  in
  place_of_point origin >>= fun origin ->
  place_of_point dest >|= fun dest ->
  [
    "origin", ["\"" ^ origin ^ "\""];
    "dest", ["\"" ^ dest ^ "\""];
    "currtime", [Printf.sprintf "%.0f" (CalendarLib.Calendar.to_unixfloat t)]
  ]

let path origin dest time =
  params origin dest time >>= get "path" >|=
  Ag_util.Json.from_string Routeserver_j.read_path

let path_retro origin dest time =
  params origin dest time >>= get "path_retro" >|=
  Ag_util.Json.from_string Routeserver_j.read_path_retro


let dump =
  let d t =
    Calendar.(of_json_o t |> Option.map Time.to_string) |>
    Option.default_to "?"
  in
  Lwt_list.iter_s Routeserver_j.(function
    | `BoardEvent {when_; what; _}
    | `StreetStartEvent {when_; what; _}
    | `StreetTurnEvent {when_; what; _}
    | `StreetEndEvent {when_; what; _} ->
      Lwt_io.printf "%s\t%s\n" (d when_) what
    | `AlightEvent {when_; where; geom = lat, lon; _} ->
      Lwt_io.printf "%s\talight at %s (%f, %f)\n" (d when_)
        (Option.default_to "?" where)
        lat lon
    | `DescribeCrossingAtAlightEvent _ ->
      Lwt.return_unit
  )
