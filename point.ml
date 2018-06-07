type t =
  | Address of string
  | GPS of {lat: float; lng: float}
  | Place of string

let to_string = function
  | Address a -> "\"" ^ a ^ "\""
  | GPS {lat; lng} -> Printf.sprintf "%f,%f" lat lng
  | Place p -> p

(* FIXME match ^ *)
let conv =
  let of_string s =
    let open Tyre in
    let re = route [
      (start *> str "sta-" --> fun _ ->
        Place s);
      (start *> str "osm-" --> fun _ ->
        Place s);
      (start *> str "place_id:" --> fun _ ->
        Place s);
      (start *> regex (Re.rg 'A' 'Z') --> fun _ ->
        Address s);
      (start *> float <&> char ',' *> (opt (char ' ')) *> float <* stop) -->
        fun (lat, lng) -> GPS {lat; lng}
    ] in
    match exec re s with
    | Ok x -> Ok x
    | Error _ -> Error (`Msg "invalid point")
  in
  let print fmt t = Format.fprintf fmt "%s" (to_string t) in
  Cmdliner.Arg.conv ~docv:"point" (of_string, print)
