open Routeserver_t

val prot: string ref
val host: string ref

type point
val point_of_stop: string -> point

val path: point -> point -> CalendarLib.Calendar.t -> path Lwt.t
val path_retro: point -> point -> CalendarLib.Calendar.t -> path_retro Lwt.t
