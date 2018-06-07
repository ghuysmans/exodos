type t =
  | Address of string
  | GPS of {lat: float; lng: float}
  | Place of string

val to_string: t -> string
val conv: t Cmdliner.Arg.converter
