(** HTTP library *)

(** HTTP error code, including redirects *)
exception HttpError of int


(** [call method path q] performs an HTTPS (default [scheme]) request. *)
val call:
  ?headers:Cohttp.Header.t ->
  ?scheme:string ->
  host:string ->
  ?port:int ->
  [`GET | `POST] ->
  string ->
  (string * string list) list ->
  string Lwt.t
