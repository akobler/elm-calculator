--------------------------------------------------
-- backend for a very simple toy calculator
-- * run the calculation expressed in an AST
module Backend exposing (..)

-- import: elm-calculator
import Grammar exposing (..)


evaluate : Exp -> Float
evaluate exp =
    case exp of
      EAdd (l, r) -> 
        (evaluate l) + (evaluate r)
      ESub (l, r) -> 
        (evaluate l) - (evaluate r)
      EMul (l, r) -> 
        (evaluate l) * (evaluate r)
      EDiv (l, r) -> 
        (evaluate l) / (evaluate r)
      ENumber num -> num
