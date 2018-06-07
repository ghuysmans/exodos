open Routeserver_t

val prot: string ref
val host: string ref

val path: Point.t -> Point.t -> Time.t option -> path Lwt.t
val path_retro: Point.t -> Point.t -> Time.t option -> path_retro Lwt.t

val dump: event list -> unit Lwt.t
