type token
val token: consumer_key:string -> secret_key:string -> token Lwt.t

(*
type line
val line_of_string: string -> line
val string_of_line: line -> string

type stop
val stop_of_string: string -> stop
val string_of_stop: stop -> string
val vehicles_of_lines: token -> line list -> Stib_t.vehicle list list Lwt.t
val vehicles: token -> line -> Stib_t.vehicle list Lwt.t
val next_at_stops: token -> stop list -> Stib_t.passing_time list list Lwt.t
val next_at_stop: token -> stop -> Stib_t.passing_time list Lwt.t
val messages_of_stops: token -> stop list -> Stib_t.message list
val messages_of_stop: token -> stop list -> Stib_t.message list
val messages_of_lines: token -> line list -> Stib_t.message list
val messages_of_line: token -> line list -> Stib_t.message list
*)
