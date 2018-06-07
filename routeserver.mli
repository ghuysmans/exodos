open Routeserver_t

val prot: string ref
val host: string ref

type vertex
val vertex_of_name: string -> vertex
val vertex_of_geo: lat:float -> lon:float -> vertex Lwt.t

val path: vertex -> vertex -> Time.t option -> path Lwt.t
val path_retro: vertex -> vertex -> Time.t option -> path_retro Lwt.t
