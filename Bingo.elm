module Bingo where

import Html
import String

-- a title function
title times message =
  message ++ " "
    |> String.toUpper
    |> String.repeat times
    |> String.trimRight
    |> Html.text


main =
  title 3 "Bingo!"
