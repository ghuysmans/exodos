open Lwt.Infix

type token = Token of string

let host = "opendata-api.stib-mivb.be"

let token ~consumer_key ~secret_key =
  let b64 = B64.encode (consumer_key ^ ":" ^ secret_key) in
  let headers = Cohttp.Header.init_with "Authorization" ("Basic " ^ b64) in
  Http.call ~headers ~host `POST "token" [] >>= fun t ->
  Lwt.return (Token t)

let get (Token t) endpoint =
  let headers = Cohttp.Header.init_with "Authorization" ("Bearer " ^ t) in
  Http.call ~headers ~host `GET endpoint []

type line = string

let vehicles token lines =
  let ids = String.concat "," lines in
  get token ("OperationMonitoring/1.0/VehiclePositionByLine/" ^ ids)
  (* FIXME parse *)

let waiting_time token lines =
  let ids = String.concat "," lines in
  get token ("OperationMonitoring/2.0/PassingTimeByPoint/" ^ ids)
  (* FIXME parse *)

let message_by_line token lines =
  let ids = String.concat "," lines in
  get token ("OperationMonitoring/2.0/MessageByLine/" ^ ids)
  (* FIXME parse *)

let message_by_stop token stops =
  let ids = String.concat "," stops in
  get token ("OperationMonitoring/2.0/MessageByPoint/" ^ ids)
  (* FIXME parse *)

let dump_positions =
  List.iter (fun v ->
    let open Stib_t in
    Printf.printf "%s,%d,%s\n" v.directionId v.distanceFromPoint v.pointId
  )
