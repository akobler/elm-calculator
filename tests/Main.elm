port module Main exposing (..)

-- basic
import ParserTests
import Test.Runner.Node exposing (run, TestProgram)
import Json.Encode exposing (Value)


main : TestProgram
main =
    run emit ParserTests.all


port emit : ( String, Value ) -> Cmd msg
