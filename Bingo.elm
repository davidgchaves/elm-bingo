module Bingo where

import Html
import String

main =
  -- Without |> operator
  -- Html.text (String.repeat 3 (String.toUpper "Hello, Elm!"))
  -- Using |> operator
  "Bingo!"
    |> String.toUpper
    |> String.repeat 3
    |> Html.text
