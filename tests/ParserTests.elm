module ParserTests exposing (..)

-- basic
import Test exposing (..)
import Expect

-- elm-calculator
import Parser exposing (..)


all : Test
all =
  describe "parser test suite"

    [ describe "#oneToken"

        [ test "Ok: eat one token" <|
          \() -> 
            let 
              inputTokens = [ "I_am_a_token", "me_too"]
              remainingTokens = ["me_too"]
            in
              Expect.equal (run oneToken inputTokens) (Ok ("I_am_a_token", remainingTokens))


        , test "Err: eat one token but none is available" <|
          \() -> 
            let 
              inputTokens = [ ]
            in
              Expect.equal (run oneToken inputTokens) (Err "no more input")
        ]
    ]