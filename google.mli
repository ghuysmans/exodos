open Google_t

exception Failure of Google_t.status

type query
val get_many: query -> route list Lwt.t
val get_one: query -> route Lwt.t

val path: Point.t -> Point.t -> Time.t option -> query
val path_retro: Point.t -> Point.t -> Time.t option -> query

type mode =
  | Driving
  | Walking
  | Bicycling

type wp =
  | Direct
  | Waypoints of Point.t list
  | Optimized_waypoints of Point.t list

val directions: ?mode:mode -> ?wp:wp -> Point.t -> Point.t -> Time.t option -> query
val directions_retro: ?mode:mode -> ?wp:wp -> Point.t -> Point.t -> Time.t option -> query
