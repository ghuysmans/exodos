open Stib_t
open Lwt.Infix

let host = "opendata-api.stib-mivb.be"

let token ~consumer_key ~secret_key =
  let b64 = Base64.encode_exn (consumer_key ^ ":" ^ secret_key) in
  let headers = Cohttp.Header.init_with "Authorization" ("Basic " ^ b64) in
  let d = ["grant_type", ["client_credentials"]] in
  Http.call ~headers ~host `POST "token" d >|=
  Ag_util.Json.from_string Stib_j.read_token

let get {token_type; access_token; _} endpoint =
  let headers =
    let a = token_type ^ " " ^ access_token in
    Cohttp.Header.init_with "Authorization" a
  in
  Http.call ~headers ~host `GET endpoint []

let vehicles_of_lines token lines =
  let ids = String.concat "," lines in
  get token ("OperationMonitoring/2.0/VehiclePositionByLine/" ^ ids) >|=
  Ag_util.Json.from_string Stib_j.read_vehicle_position >|= fun t ->
  List.map (fun l -> l.lineId, l.vehiclePositions) t.vp_lines


let next_at_stops token lines =
  let ids = String.concat "," lines in
  get token ("OperationMonitoring/2.0/PassingTimeByPoint/" ^ ids) >|=
  Ag_util.Json.from_string Stib_j.read_passing_time >|= fun t ->
  t.points |> List.map (fun p ->
    p.pointId,
    p.passingTimes |> List.map (fun {expectedArrivalTime; at_lineId} ->
      at_lineId, expectedArrivalTime
    )
  )


let messages_of_lines token lines =
  let ids = String.concat "," lines in
  get token ("OperationMonitoring/2.0/MessageByLine/" ^ ids) >|=
  Ag_util.Json.from_string Stib_j.read_messages >|= fun t ->
  t.messages

let messages_of_stops token stops =
  let ids = String.concat "," stops in
  get token ("OperationMonitoring/2.0/MessageByPoint/" ^ ids) >|=
  Ag_util.Json.from_string Stib_j.read_messages >|= fun t ->
  t.messages
