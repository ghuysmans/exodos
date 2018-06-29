open Stib_t

val token: consumer_key:string -> secret_key:string -> token Lwt.t

(*
val line_of_string: string -> line
val string_of_line: line -> string
*)

(*
val stop_of_string: string -> stop
val string_of_stop: stop -> string
*)
val vehicles_of_lines: token -> line list -> (line * vehicle list) list Lwt.t
val next_at_stops: token -> stop list -> (stop * (line * time) list) list Lwt.t
val messages_of_stops: token -> stop list -> message list Lwt.t
val messages_of_lines: token -> line list -> message list Lwt.t
