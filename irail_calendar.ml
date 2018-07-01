type t = CalendarLib.Calendar.t

let wrap i = CalendarLib.Calendar.from_unixfloat (float_of_int i)
let unwrap f = int_of_float (CalendarLib.Calendar.to_unixfloat f)
