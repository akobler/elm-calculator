--------------------------------------------------
-- main program
-- * view UI
-- * receive user input
-- * trigger parser (Parser.run)

-- import: elm basic libs
import Html exposing (..)
import Html.Attributes
import Html.Events exposing (..)

-- import: elm-calculator
import Tokenizer exposing (..)
import Parser exposing (..)
import Grammar exposing (..)
import Backend exposing (..)


main =
  Html.beginnerProgram
    { model = modelInit
    , view = view
    , update = update
    }

modelInit : Model
modelInit = 
  { input = ""
  , tokens = []
  , parseResult = Err "no Input"
  , evaluation = Nothing
  }


--------------------------------------------------
-- MODEL
type alias Model = 
  { input : String
  , tokens : List Token
  , parseResult : Result String (Grammar.Exp, Tokens) -- return value of Parser.run
  , evaluation : Maybe Float
  }

type alias Token = String


--------------------------------------------------
-- UPDATE
type Msg = SetInput String

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetInput input -> { model | input = input }
    |> updateTokens
    |> updateParseResult
    |> updateEvaluation


updateTokens : Model -> Model
updateTokens model =
  { model | tokens = Tokenizer.tokenize model.input }

updateParseResult : Model -> Model
updateParseResult model =
  { model | parseResult = parse model.tokens }

parse : List Token -> Result String (Grammar.Exp, Tokens)
parse tokens = Parser.run Grammar.expression tokens


updateEvaluation : Model -> Model
updateEvaluation model =
  case checkParseResult model.parseResult of
    Err _ -> { model | evaluation = Nothing }
    Ok (expression, _) ->     
      { model | evaluation = Just (Backend.evaluate expression)}


checkParseResult : Result String (a, Tokens) -> Result String (a, Tokens)
checkParseResult parseResult =
  case parseResult of
    Ok (_, tokens) -> 
      case List.isEmpty tokens of
        False -> Err ("tokens remaining: " ++ toString tokens)
        _ -> parseResult
    _ -> parseResult


--------------------------------------------------
-- VIEW
view : Model -> Html Msg
view model = div 
  [] 
  [ div []
    [ text "input: "
    , input [onInput SetInput] [ ]
    ]
  , div []
    [ h3 [] [text "Input"]
    , text model.input
    , h3 [] [text "Tokens"]
    , model.tokens |> toString |> text
    , h3 [] [text "Parser"]
    , h4 [] [text "State"]
    , model.parseResult |> toString |> text
    , h4 [] [text "Result"]
    , viewParseResult model.parseResult
    , h3 [] [text "Evaluation"]
    , model.evaluation |> toString |> text
    ]
  ]

viewParseResult : Result String (a, Tokens) -> Html Msg
viewParseResult parseResult =
  let
    checkedParseResult = checkParseResult parseResult
  in
    case checkedParseResult of
      Err msg -> div [errorStyle] [text msg]
      Ok _ -> div [successStyle] [text "OK"]
        

errorStyle : Attribute msg
errorStyle =
  Html.Attributes.style [ ("backgroundColor", "LightCoral "), ("display", "inline") ]

successStyle : Attribute msg
successStyle =
  Html.Attributes.style [ ("backgroundColor", "LightGreen "), ("display", "inline") ]