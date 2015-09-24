module Bingo where

import Html            exposing (h1, text, footer, a, div, span, ul, li)
import Html.Attributes exposing (id, class, href)
import String          exposing (toUpper, repeat, trimRight)

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
type Action = NoOp | Sort

update action model =
  case action of
    NoOp -> model
    Sort -> { model | entries <- List.sortBy .points model.entries }
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


entryList entries =
  ul [] (List.map entryItem entries)


entryItem entry =
  li []
    [ span [ class "phrase" ] [ text entry.phrase],
      span [ class "points" ] [ text (toString entry.points) ]
    ]


view model =
  div [ id "container" ]
    [ pageHeader,
      entryList model.entries,
      pageFooter
    ]
-- END VIEW


-- WIRE IT ALL TOGETHER!
main =
  view (update Sort initialModel)
