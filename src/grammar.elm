--------------------------------------------------
-- grammar for a very simple toy calculator
-- * simple mul/div before add/sub is implemented
-- * recursion is not implemented
module Grammar exposing (..)

-- import: elm-calculator
import Parser exposing (..)


-- AST datatype
type Exp =
  EAdd (Exp, Exp)
  | ESub (Exp, Exp)
  | EMul (Exp, Exp)
  | EDiv (Exp, Exp)
  | ENumber Float


-- parsers
expression : Parser Exp
expression = 
  (term .>> plus .>>. term               |>> EAdd)
  <|> (term .>> minus .>>. term          |>> ESub)
  <|> term

term : Parser Exp
term = 
  (number .>> star .>>. number           |>> EMul)
  <|> (number .>> slash .>>. number      |>> EDiv)
  <|> number

number : Parser Exp
number = 
  float                                  |>> ENumber

plus : Parser Token
plus = expect "+"

minus : Parser Token
minus = expect "-"

star : Parser Token
star = expect "*"

slash : Parser Token
slash = expect "/"
