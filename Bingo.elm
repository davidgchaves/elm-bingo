module Bingo where

import Html            exposing (Html, Attribute, h1, h2, text, footer, a, div, span, ul, li, button, input)
import Html.Attributes exposing (id, class, href, classList, type', name, autofocus, placeholder, value)
import Html.Events     exposing (onClick, on, targetValue)
import String          exposing (toUpper, repeat, trimRight)
import Signal          exposing (Address)
import StartApp.Simple as StartApp

-- HELPERS
{-
From Html.Events docs:
  http://package.elm-lang.org/packages/evancz/elm-html/4.0.1/Html-Events#on
  on : String -> Decoder a -> (a -> Message) -> Attribute
  Create a custom event listener.

  http://package.elm-lang.org/packages/evancz/elm-html/4.0.1/Html-Events#targetValue
  targetValue : Decoder String
  A Json.Decoder for grabbing event.target.value from the triggered event.
  This is often useful for input event on text fields.
-}
onInput : Address a -> (String -> a) -> Attribute
onInput address contentToValue =
  on "input" targetValue (\str -> Signal.message address (contentToValue str))

parseInt : String -> Int
parseInt str =
  case String.toInt str of
    Ok value  -> value
    Err error -> 0
-- END HELPERS


-- MODEL
type alias Entry =
  { phrase: String,
    points: Int,
    wasSpoken: Bool,
    id: Int
  }

type alias Model =
  { entries: List Entry,
    phraseInput: String,
    pointsInput: String,
    nextId: Int
  }


newEntry : String -> Int -> Int -> Entry
newEntry phrase points id = Entry phrase points False id

-- REMEMBER: Mantain all the state in the Model
initialModel : Model
initialModel =
  { entries =
    [ newEntry "In the Cloud" 300 3,
      newEntry "Future-Proof" 100 1,
      newEntry "Doing Agile"  200 2
    ],
    phraseInput = "",
    pointsInput = "",
    nextId = 4
  }
-- END MODEL


-- UPDATE
type Action
  = NoOp
  | Sort
  | Delete Int
  | Mark Int
  | UpdatePhraseInput String
  | UpdatePointsInput String
  | Add

update : Action -> Model -> Model
update action model =
  case action of
    NoOp      -> model
    Sort      -> { model | entries <- List.sortBy (\e -> e.points) model.entries }
    Delete id -> { model | entries <- List.filter (\e -> e.id /= id) model.entries }
    Mark id   ->
      let updateEntry e = if e.id == id then { e | wasSpoken <- (not e.wasSpoken) } else e
      in { model | entries <- List.map updateEntry model.entries }
    UpdatePhraseInput contents -> { model | phraseInput <- contents }
    UpdatePointsInput contents -> { model | pointsInput <- contents }
    Add ->
      let
        entryToAdd      = newEntry model.phraseInput (parseInt model.pointsInput) model.nextId
        isInvalid model = String.isEmpty model.phraseInput || String.isEmpty model.pointsInput
      in
        if isInvalid model
        then model
        else
          { model |
            phraseInput <- "",
            pointsInput <- "",
            entries     <- entryToAdd :: model.entries,
            nextId      <- model.nextId + 1
          }
-- END UPDATE


-- VIEW
title : Int -> String -> Html
title times message =
  message ++ " "
    |> toUpper
    |> repeat times
    |> trimRight
    |> text


pageHeader : Html
pageHeader =
  h1 [ id "logo", class "classy" ] [ title 3 "Bingo!" ]


pageFooter : Html
pageFooter =
  footer []
    [ a [ href "http://elm-lang.org/" ]
        [ text "The Elm Language Homepage"]
    ]


totalPoints : List Entry -> Int
totalPoints entries =
  entries
    |> List.filter .wasSpoken
    |> List.foldl (\e acc -> acc + e.points) 0


totalItem : Int -> Html
totalItem total =
  li
    [ class "total" ]
    [ span [ class "label" ] [ text "Total" ],
      span [ class "points" ] [ text (toString total) ]
    ]


entryList : Address Action -> List Entry -> Html
entryList address entries =
  let
    entryItems = List.map (entryItem address) entries
    items = entryItems ++ [ totalItem (totalPoints entries) ]
  in  ul [] items


entryItem : Address Action -> Entry -> Html
entryItem address entry =
  li
    [ classList [ ("highlight", entry.wasSpoken) ],
      onClick address (Mark entry.id)
    ]
    [ span [ class "phrase" ] [ text entry.phrase],
      span [ class "points" ] [ text (toString entry.points) ],
      button [ class "delete", onClick address (Delete entry.id) ] []
    ]


entryForm : Address Action -> Model -> Html
entryForm address model =
  div []
    [ input
        [ type' "text",
          placeholder "Phrase",
          value model.phraseInput,
          name "phrase",
          autofocus True,
          onInput address UpdatePhraseInput
        ]
        [],
      input
        [ type' "number",
          placeholder "Points",
          value model.pointsInput,
          name "points",
          onInput address UpdatePointsInput
        ]
        [],
      button
        [ class "add",
          onClick address Add
        ]
        [ text "Add" ],
      h2
        []
        [ text (model.phraseInput ++ " " ++ model.pointsInput) ]
    ]

view : Address Action -> Model -> Html
view address model =
  div [ id "container" ]
    [ pageHeader,
      entryForm address model,
      entryList address model.entries,
      button [ class "sort", onClick address Sort ] [ text "Sort" ],
      pageFooter
    ]
-- END VIEW


-- WIRE IT ALL TOGETHER!
main : Signal Html
main = StartApp.start { model = initialModel, view = view, update = update }
