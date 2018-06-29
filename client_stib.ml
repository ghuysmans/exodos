open Stib
open Stib_t
open Lwt.Infix

let () = Lwt_main.run (
  Config.(token ~consumer_key:stib_ck ~secret_key:stib_sk) >>= fun token ->
  messages_of_stops token ["3064"] >>=
  (*
  Lwt_list.iter_s (fun (l, vs) ->
    Lwt_io.printf "%s:\n" l >>= fun () ->
    (*
    vs |> Lwt_list.iter_s (fun {directionId; distanceFromPoint; pointId} ->
      Lwt_io.printf "dir=%s, dist=%d, point=%s\n"
        directionId distanceFromPoint pointId
    )
    *)
    vs |> Lwt_list.iter_s (fun (l, t) ->
      Lwt_io.printf "t=%s, line=%s\n" (Calendar.to_json t) l
    )
  *)
  Lwt_list.iter_s (fun m ->
    let c = List.hd m.content in
    Lwt_io.printf "fr=%s\n" c.text.fr >>= fun () ->
    m.points |> Lwt_list.iter_s (fun {id} ->
      Lwt_io.printf " %s\n" id
    )
  ) >>= fun () ->
  Lwt_io.printl "done"
)
