type stop = {
  stop_id: string;
  stop_name: string;
  stop_lat: float;
  stop_lon: float
}

type stops
val of_file: string -> stops Lwt.t
val find_by_prefix: stops -> string -> stop
