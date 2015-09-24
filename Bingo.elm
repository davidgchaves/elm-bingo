module Bingo where

import Html            exposing (h1, text, footer, a, div, span, ul, li)
import Html.Attributes exposing (id, class, href)
import String          exposing (toUpper, repeat, trimRight)

-- a title function
title times message =
  message ++ " "
    |> toUpper
    |> repeat times
    |> trimRight
    |> text


-- the pageHeader Component
pageHeader =
  h1 [ id "logo", class "classy" ] [ title 3 "Bingo!" ]


-- the pageFooter Component
pageFooter =
  footer []
    [ a [ href "http://elm-lang.org/" ]
        [ text "The Elm Language Homepage"]
    ]


-- the entryList Component
entryList =
  ul []
    [ entryItem "Future-Proof" 100,
      entryItem "Doing Agile" 200
    ]


-- the entryItem Component
entryItem phrase points =
  li []
    [ span [ class "phrase" ] [ text phrase],
      span [ class "points" ] [ text (toString points) ]
    ]


-- the view Component
view =
  div [ id "container" ]
    [ pageHeader,
      entryList,
      pageFooter
    ]


main =
  view
