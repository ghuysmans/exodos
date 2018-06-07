open Lwt.Infix

type stop = {
  stop_id: string;
  stop_name: string;
  stop_lat: float;
  stop_lon: float
}

type stops = stop array

let of_file filename =
  Csv_lwt.load filename >|=
  List.tl >|= (* skip the header *)
  List.map (function
    | [stop_id; _; stop_name; _; stop_lat; stop_lon; _; _; _] ->
      let stop_lat = float_of_string stop_lat in
      let stop_lon = float_of_string stop_lon in
      {stop_id; stop_name; stop_lat; stop_lon}
    | _ ->
      failwith @@ "malformed line in " ^ filename
  ) >|=
  Array.of_list

exception Found of stop

let find_by_prefix arr p =
  try
    arr |> Array.iter (fun ({stop_name; _} as s) ->
      let l = String.length p in
      if String.length stop_name >= l && String.sub stop_name 0 (l - 1) = p then
        raise (Found s)
      else
        ()
    );
    raise Not_found
  with Found s ->
    s
