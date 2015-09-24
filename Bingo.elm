module Bingo where

import Html            exposing (h1, text, footer, a, div)
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


main =
  div [ id "container" ] [ pageHeader, pageFooter ]
