open Irail_j
open Lwt.Infix

let get endpoint p =
  let headers = Cohttp.Header.init_with "User-Agent" "Exodos/1.0" in
  let p = ("format", ["json"]) :: p in
  Http.call ~headers ~host:"api.irail.be" `GET endpoint p

let add_date d h =
  let open CalendarLib.Calendar in
  match d with
  | Some d ->
    ("date", [Printf.sprintf "%02d%02d%02d"
      (day_of_month d)
      (month d |> CalendarLib.Date.int_of_month)
      (year d - 2000)]) ::
    ("time", [Printf.sprintf "%02d%02d"
      (hour d) (minute d)]) ::
    h
  | None ->
    h

let lb_param_of_place = Point.(function
  | Address st -> "station", [st]
  | GPS _ -> failwith "iRail doesn't support GPS coordinates"
  | Place id -> "id", [id]
)

let arrivals ?t st =
  let p = add_date t [lb_param_of_place st; "arrdep", ["arrival"]] in
  get "/liveboard/" p >|= fun s ->
  (Ag_util.Json.from_string read_liveboard_a s).arrivals

let departures ?t st =
  let p = add_date t [lb_param_of_place st; "arrdep", ["departure"]] in
  get "/liveboard/" p >|= Ag_util.Json.from_string read_liveboard_d >|= fun t ->
  t.departures

let param_of_place n = Point.(function
  | Address st -> n, [st]
  | GPS _ -> failwith "iRail doesn't support GPS coordinates"
  | Place id -> n, [id]
)

let path_ ts origin dest t =
  let p = add_date t [
    param_of_place "from" origin;
    param_of_place "to" dest;
    "timeSel", [match ts with `Arrive -> "arrive" | `Depart -> "depart"];
  ] in
  get "/connections/" p >|= fun s ->
  (Ag_util.Json.from_string read_connections s).connection

let path = path_ `Depart
let path_retro = path_ `Arrive


let vehicle v d =
  let p =
    ("id", [v]) ::
    match d with
    | None -> []
    | Some t -> ["date", CalendarLib.Calendar.[Printf.sprintf "%02d%02d%02d"
      (day_of_month t) (CalendarLib.Date.int_of_month (month t)) (year t)]]
  in
  get "/connections/" p >|= fun s ->
  (Ag_util.Json.from_string read_connections s).connection
