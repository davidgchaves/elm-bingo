module Bingo where

import Html   exposing (..)
import String exposing (toUpper, repeat, trimRight)

-- a title function
title times message =
  message ++ " "
    |> toUpper
    |> repeat times
    |> trimRight
    |> text


main =
  title 3 "Bingo!"
