let default_to d = function
  | Some x -> x
  | None -> d

let map f = function
  | Some x -> Some (f x)
  | None -> None
