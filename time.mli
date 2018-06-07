open CalendarLib

type t = Calendar.t

val to_string: t -> string
val conv: t Cmdliner.Arg.converter
