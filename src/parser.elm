--------------------------------------------------
-- minimalistic parser combinator library
-- stripped to a bare minimum for the simple calculator example
-- for more inspiration check: https://fsharpforfunandprofit.com/parser/
module Parser exposing (..)

-- basic
import String


-- token definition
----------------------------------------------------------
type alias Token = String
type alias Tokens = List Token


-- parser definition
----------------------------------------------------------
type alias ParserFn a = Tokens -> Result String (a, Tokens)
type Parser a = 
  Parser (ParserFn a)

run : Parser a -> Tokens -> Result String (a, Tokens)
run parser tokens = 
  case parser of
    Parser innerFn -> innerFn tokens


-- simple parsers
----------------------------------------------------------
oneToken : Parser Token
oneToken =
  let innerFn input =
    let
      maybeToken = List.head input
      remainingTokens = List.drop 1 input
    in
      case maybeToken of
        Nothing -> Err "no more input"
        Just token -> Ok(token, remainingTokens) 
  in
    Parser innerFn

expect : Token -> Parser Token
expect expectedToken =
  let
    compareTokens token = 
      if token == expectedToken then
        return token
      else
        returnErr ("token ("++ toString token ++") does not match expected token ("++ toString expectedToken ++")")
  in
    oneToken >>= compareTokens

float : Parser Float
float =
  oneToken              -- type: Parser Token
  |>> String.toFloat    -- type: Parser (Result String Float)
  >>= liftResult        -- type: Parser Float

-- function signatures to ease the type tetris above:
-- String.toFloat -- type: String -> Result String Float
-- liftResult     -- type: Result String a -> Parser a


-- combining parsers
----------------------------------------------------------

-- Combine two parsers as "A and B", create a parser that returns both
-- results in a pair
and : Parser a -> Parser b -> Parser ( a, b )
and p1 p2 =         
  p1 >>= (\p1Result -> 
  p2 >>= (\p2Result -> 
    return (p1Result,p2Result) ))

-- Infix version of and
(.>>.) : Parser a -> Parser b -> Parser ( a, b )
(.>>.) = and


-- Combine two parsers as "A or B"
or : Parser a -> Parser a -> Parser a
or p1 p2 =
  let innerFn tokens =
    let
      result1 = run p1 tokens        -- run parser1 with the tokens
    in
      case result1 of
        Ok _ -> result1             -- on success, return the original result
        Err err -> run p2 tokens     -- on failure, run parser2 with the tokens
  in
    Parser innerFn

-- Infix version of or
(<|>) : Parser a -> Parser a -> Parser a
(<|>) = or


-- Keep only the result of the left side parser
(.>>) : Parser a -> Parser b -> Parser a
(.>>) p1 p2 =
  p1 .>>. p2            -- create a pair
  |> map (\(a,b) -> a)  -- then only keep the second value


-- Keep only the result of the right side parser
(>>.) : Parser a -> Parser b -> Parser b
(>>.) p1 p2 = 
  p1 .>>. p2            -- create a pair
  |> map (\(a,b) -> b)  -- then only keep the second value


-- higher order and helper functions
----------------------------------------------------------

-- takes a parser-producing function f, and a parser p
-- and passes the output of p into f to create a new parser
andThen : (b -> Parser a) -> Parser b -> Parser a
andThen f p =
  let innerFn tokens =
    let 
      result1 = run p tokens             -- run given parser p1 with tokens
    in
      case result1 of
        Err err -> Err err               -- return error from parser1
        Ok (value1, remainingTokens) ->  -- if result Ok: apply given f to get a new parser p2
          let 
            p2 = f value1                -- pipe value1 into parser-producing function f -> produce p2
          in 
            run p2 remainingTokens       -- run parser with remaining tokens
  in
    Parser innerFn

bind = andThen

(>>=) : Parser b -> (b -> Parser a) -> Parser a
(>>=) p f = bind f p


-- Lift a value to a Parser
return : a -> Parser a
return x = 
    let innerFn input =
      Ok (x,input)          -- ignore the input and return x
    in
      Parser innerFn        -- return the inner function

-- Lift an error to a Parser
returnErr : String -> Parser a
returnErr errMsg = 
    let innerFn input =
      Err errMsg            -- ignore the input and return an error
    in
      Parser innerFn        -- return the inner function

-- Lift a result to a Parser
liftResult : Result String a -> Parser a
liftResult result =
  case result of
    Err msg -> returnErr msg
    Ok val -> return val


-- apply a function to a wrapped value
map : (a -> a1) -> Parser a -> Parser a1
map f = 
    bind (f >> return)

-- piping version of map
(|>>) : Parser a -> (a -> a1) -> Parser a1
(|>>) x f = map f x
