module Bingo where

import Html            exposing (h1, text)
import Html.Attributes exposing (id, class)
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


main =
  pageHeader
