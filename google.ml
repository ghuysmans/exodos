open Google_t
open Lwt.Infix

type point =
  | Address of string
  | GPS of {lat: float; lng: float}
  | Place of string

let string_of_point = function
  | Address s -> s
  | GPS {lat; lng} -> Printf.sprintf "%f,%f" lat lng
  | Place p -> "place_id:" ^ p

exception Failure of Google_t.status

let assert_ok {status; routes} =
  if status = `OK then
    Lwt.return routes
  else
    Lwt.fail (Failure status)

type wp =
  | Direct
  | Waypoints of point list
  | Optimized_waypoints of point list

let directions_ ~time_p mode ?(wp=Direct) origin destination t alt =
  let t =
    match t with
    | None -> CalendarLib.Calendar.now ()
    | Some t -> t
  in
  let p = [
    "origin", [string_of_point origin];
    "destination", [string_of_point destination];
    "key", [Config.google_maps_key];
    "mode", [mode];
    "alternatives", [if alt then "true" else "false"];
    time_p, [Printf.sprintf "%.0f" (CalendarLib.Calendar.to_unixfloat t)];
  ] in
  let p =
    let f prefix l =
      if l = [] then
        p (* don't send an empty waypoints parameter *)
      else
        ("waypoints",
          [prefix ^ String.concat "|" (List.map string_of_point l)]) :: p
    in
    match wp with
    | Direct -> f "" []
    | Waypoints wp -> f "" wp
    | Optimized_waypoints wp -> f "optimize:true|" wp
  in
  Http.call ~host:"maps.googleapis.com" `GET "/maps/api/directions/json" p >|=
  Ag_util.Json.from_string Google_j.read_path >>= assert_ok

let path_ ~time_p =
  directions_ ~time_p "transit" ?wp:None

type query = bool -> route list Lwt.t
let path = path_ ~time_p:"departure_time"
let path_retro = path_ ~time_p:"arrival_time"

let get_many f = f false
let get_one f = f false >|= List.hd

type mode =
  | Driving
  | Walking
  | Bicycling

let string_of_mode = function
  | Driving -> "driving"
  | Walking -> "walking"
  | Bicycling -> "bicycling"

let directions ?(mode=Driving) =
  directions_ ~time_p:"departure_time" (string_of_mode mode)

let directions_retro ?(mode=Driving) =
  directions_ ~time_p:"arrival_time" (string_of_mode mode)
