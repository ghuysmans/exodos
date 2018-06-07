open Google_t

type point =
  | Address of string
  | GPS of {lat: float; lng: float}
  | Place of string

exception Failure of Google_t.status

type query
val get_many: query -> route list Lwt.t
val get_one: query -> route Lwt.t

val path: point -> point -> Time.t option -> query
val path_retro: point -> point -> Time.t option -> query

type mode =
  | Driving
  | Walking
  | Bicycling

type wp =
  | Direct
  | Waypoints of point list
  | Optimized_waypoints of point list

val directions: ?mode:mode -> ?wp:wp -> point -> point -> Time.t option -> query
val directions_retro: ?mode:mode -> ?wp:wp -> point -> point -> Time.t option -> query
