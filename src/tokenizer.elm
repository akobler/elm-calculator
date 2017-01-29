--------------------------------------------------
-- very primitive tokenizer: 
-- * split by space
-- * filter empty strings
module Tokenizer exposing (..)

tokenize : String -> List String
tokenize input =
  String.split " " input
  |> List.filter (String.isEmpty >> not)
