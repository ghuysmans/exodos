open Routeserver_t

val prot: string ref
val host: string ref

type vertex
val vertex_of_geo: lat:float -> lon:float -> vertex Lwt.t

val path: vertex -> vertex -> CalendarLib.Calendar.t -> path Lwt.t
val path_retro: vertex -> vertex -> CalendarLib.Calendar.t -> path_retro Lwt.t
