type t = {
  p : Player.m list ; 
  n : int
}

let make n : t =
  let rec loop = function
  | 0 -> []
  | i -> Player.N::(loop (i - 1))
  in 
  let list_player = loop (n * n) in
  { p = list_player; n = n }


let toggle (r, c) m b =
  let i = c + (r * b.n) in
  let f index e =
    if index <> i then e
    else m
  in
  let newl = List.mapi f b.p in
  {p = newl; n = b.n}

let mark_of (r, c) b =
  let i = c + (r * b.n) in
  let f = function 
    | (Player.X : Player.m) -> Player.X
    | Player.O -> Player.O
    | _ -> Player.N
  in
  let rec loop l acc = match l with
    | [] -> Player.N (* no possible because r c must be valid *)
    | hd :: tl ->
      if acc = i then f hd
      else loop tl (acc + 1)
  in
  loop b.p 0

let isTaken (r, c) b =
  let i = c + (r * b.n) in
  let f = function 
    | (Player.X : Player.m) | Player.O -> true
    | _ -> false
  in
  let rec loop l acc = match l with
    | [] -> false
    | hd :: tl ->
      if acc = i then f hd
      else loop tl (acc + 1)
  in
  loop b.p 0


let winner_of b =
  let same value value1 = value in
  let win p i =
    let rec check (y, x) opey opex =
      if ((y < 0) || (y >= b.n)) || ((x < 0) || (x >= b.n)) then true
      else
        let newi = x + (y * b.n) in 
        if ((newi < 0) || (newi >= (List.length b.p))) then false else
          let newp = List.nth b.p newi in
          if p <> newp then false
          else check ((opey y 1), (opex x 1)) opey opex
    in
    let y = i / b.n in let x = i mod b.n in
    let top = check ((y - 1), x) (-) same in let bottom = check ((y + 1), x) (+) same in
    let left = check (y, (x - 1)) same (-) in let rigth = check (y, (x + 1)) same (+) in
    let bottomRigth = check ((y + 1), (x + 1)) (+) (+) in let topLeft = check ((y - 1), (x - 1)) (-) (-) in
    let bottomLeft = check ((y + 1), (x - 1)) (+) (-) in let topRigth = check ((y - 1), (x + 1)) (-) (+) in
    ((top && (y > 0)) && (bottom && (y < (b.n - 1)))) ||
    ((left && (x > 0)) && (rigth && (x < (b.n - 1)))) ||
    ((bottomRigth && (y > 0) && (x < (b.n - 1))) && (topLeft && (y < (b.n - 1)) && (x > 0))) ||
    ((bottomLeft && (y > 0) && (x > 0)) && (topRigth && (y < (b.n - 1)) && (x < (b.n -1))))
  in
  let rec loop l i =
    match l with
    | [] -> Player.N
    | hd :: tl when hd = Player.N -> loop tl (i + 1)
    | hd :: tl -> if win hd i then hd else loop tl (i + 1)
  in loop b.p 0

let rec dump b =
  let f i a =
    print_string (Player.string_of_mark a) ;
    print_char (if (((i + 1) mod b.n) = 0) && i <> 0 then '\n' else ' ')
  in List.iteri f b.p

let draw dx dy b =
  let f i m =
    let x = (i mod b.n) in let y = (i / b.n) in
    print_int i ; print_string ": x -> "; print_int x ; print_string " y ->" ; print_int y ; print_char '\n' ;
    Graphics.moveto (dx + (x * 20)) (dy - (y * 20));
    Graphics.draw_string (Player.string_of_mark m)
  in List.iteri f b.p

let string_of b : string list = 
  let rec loop l acc line = match l with
    | [] -> line :: []
    | hd :: tl when (((acc + 1) mod b.n) = 0 && acc <> 0) ->
      (line ^ " " ^ Player.string_of_mark hd) :: (loop tl (acc + 1) "")
    | hd :: tl -> let sepa = if ((acc mod b.n) = 0) then "" else " "  in
      loop tl (acc + 1) (line ^ sepa ^ (Player.string_of_mark hd))
  in loop b.p 0 ""
