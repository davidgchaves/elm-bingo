module Bingo where

import Html            exposing (h1, text, footer, a, div, span, ul, li, button)
import Html.Attributes exposing (id, class, href, classList)
import Html.Events     exposing (onClick)
import String          exposing (toUpper, repeat, trimRight)
import StartApp.Simple as StartApp

-- MODEL
newEntry phrase points id =
  { phrase = phrase,
    points = points,
    wasSpoken = False,
    id = id
  }


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
title times message =
  message ++ " "
    |> toUpper
    |> repeat times
    |> trimRight
    |> text


pageHeader =
  h1 [ id "logo", class "classy" ] [ title 3 "Bingo!" ]


pageFooter =
  footer []
    [ a [ href "http://elm-lang.org/" ]
        [ text "The Elm Language Homepage"]
    ]


totalPoints entries =
  let spokenEntries = List.filter .wasSpoken entries
  in  List.sum (List.map .points spokenEntries)

totalItem total =
  li
    [ class "total" ]
    [ span [ class "label" ] [ text "Total" ],
      span [ class "points" ] [ text (toString total) ]
    ]

entryList address entries =
  let
    entryItems = List.map (entryItem address) entries
    items = entryItems ++ [ totalItem (totalPoints entries) ]
  in  ul [] items


entryItem address entry =
  li
    [ classList [ ("highlight", entry.wasSpoken) ],
      onClick address (Mark entry.id)
    ]
    [ span [ class "phrase" ] [ text entry.phrase],
      span [ class "points" ] [ text (toString entry.points) ],
      button [ class "delete", onClick address (Delete entry.id) ] []
    ]


view address model =
  div [ id "container" ]
    [ pageHeader,
      entryList address model.entries,
      button [ class "sort", onClick address Sort ] [ text "Sort" ],
      pageFooter
    ]
-- END VIEW


-- WIRE IT ALL TOGETHER!
main =
  StartApp.start { model = initialModel, view = view, update = update }
