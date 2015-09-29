module Bingo where

import Html            exposing (Html, h1, text, footer, a, div, span, ul, li, button)
import Html.Attributes exposing (id, class, href, classList)
import Html.Events     exposing (onClick)
import String          exposing (toUpper, repeat, trimRight)
import Signal          exposing (Address)
import StartApp.Simple as StartApp

-- MODEL
type alias Entry =
  { phrase: String,
    points: Int,
    wasSpoken: Bool,
    id: Int
  }

type alias Model = { entries: List Entry }


newEntry : String -> Int -> Int -> Entry
newEntry phrase points id = Entry phrase points False id

initialModel : Model
initialModel =
  { entries =
    [ newEntry "In the Cloud" 300 3,
      newEntry "Future-Proof" 100 1,
      newEntry "Doing Agile"  200 2
    ]
  }
-- END MODEL


-- UPDATE
type Action
  = NoOp
  | Sort
  | Delete Int
  | Mark Int

update : Action -> Model -> Model
update action model =
  case action of
    NoOp      -> model
    Sort      -> { model | entries <- List.sortBy (\e -> e.points) model.entries }
    Delete id -> { model | entries <- List.filter (\e -> e.id /= id) model.entries }
    Mark id   ->
      let updateEntry e = if e.id == id then { e | wasSpoken <- (not e.wasSpoken) } else e
      in { model | entries <- List.map updateEntry model.entries }

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


view : Address Action -> Model -> Html
view address model =
  div [ id "container" ]
    [ pageHeader,
      entryList address model.entries,
      button [ class "sort", onClick address Sort ] [ text "Sort" ],
      pageFooter
    ]
-- END VIEW


-- WIRE IT ALL TOGETHER!
main : Signal Html
main = StartApp.start { model = initialModel, view = view, update = update }
