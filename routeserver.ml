open Lwt.Infix

let prot = ref "http"
let port = ref 8080
let host = ref "127.0.0.1"

type vertex = string

let params origin dest time = [
  "origin", ["\"" ^ origin ^ "\""];
  "dest", ["\"" ^ dest ^ "\""];
  "currtime", [Printf.sprintf "%.0f" (CalendarLib.Calendar.to_unixfloat time)]
]

let get endpoint p =
  Http.call ~scheme:!prot ~host:!host ~port:!port `GET endpoint p

let vertex_of_geo ~lat ~lon =
  let sof = Printf.sprintf "%f" in
  get "get_vertex_id" ["lat", [sof lat]; "lon", [sof lon]] >|=
  Ag_util.Json.from_string Routeserver_j.read_vertex_id

let path origin dest time =
  get "path" (params origin dest time) >|=
  Ag_util.Json.from_string Routeserver_j.read_path

let path_retro origin dest time =
  get "path_retro" (params origin dest time) >|=
  Ag_util.Json.from_string Routeserver_j.read_path_retro
