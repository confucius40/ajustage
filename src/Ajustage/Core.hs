module Ajustage.Core
  ( Buffer(..)
  , Cursor(..)
  , Position(..)
  , Direction(..)
  , empty
  , fromText
  , insert
  , delete
  , backspace
  , move
  , moveLine
  , moveStart
  , moveEnd
  , getText
  ) where

import Data.Text (Text)
import qualified Data.Text as T

data Position = Position
  { line :: Int
  , column :: Int
  } deriving (Eq, Show)

data Cursor = Cursor
  { position :: Position
  } deriving (Eq, Show)

data Buffer = Buffer
  { text :: Text
  , cursor :: Cursor
  } deriving (Eq, Show)

data Direction
  = Left'
  | Right'
  | Up
  | Down
  deriving (Eq, Show)

empty :: Buffer
empty = Buffer
  { text = ""
  , cursor = Cursor (Position 0 0)
  }

fromText :: Text -> Buffer
fromText txt = Buffer
  { text = txt
  , cursor = Cursor (Position 0 0)
  }

getText :: Buffer -> Text
getText = text

insert :: Text -> Buffer -> Buffer
insert txt buffer =
  let
    pos = position (cursor buffer)
    ls = T.lines (text buffer)
    current = lineText ls (line pos)
    before = T.take (column pos) current
    after = T.drop (column pos) current
    result = before <> txt <> after
    newColumn = column pos + T.length txt
    newLines = T.splitOn "\n" result
    rebuilt = replaceLine ls (line pos) newLines
    newPos =
      if length newLines == 1
        then Position (line pos) newColumn
        else Position
          (line pos + length newLines - 1)
          (T.length (last newLines))
  in
    buffer
      { text = T.intercalate "\n" rebuilt
      , cursor = Cursor newPos
      }

delete :: Buffer -> Buffer
delete buffer =
  let
    pos = position (cursor buffer)
    ls = T.lines (text buffer)
    current = lineText ls (line pos)
  in
    if column pos < T.length current
      then
        let
          before = T.take (column pos) current
          after = T.drop (column pos + 1) current
          rebuilt = replaceLine ls (line pos) [before <> after]
        in buffer { text = T.intercalate "\n" rebuilt }
      else if line pos < length ls - 1
        then
          let
            next = lineText ls (line pos + 1)
            merged = current <> next
            rebuilt = replaceLine ls (line pos) [merged]
          in
            buffer { text = T.intercalate "\n" (dropLine rebuilt (line pos + 1)) }
        else
          buffer

backspace :: Buffer -> Buffer
backspace buffer =
  let
    pos = position (cursor buffer)
    ls = T.lines (text buffer)
    current = lineText ls (line pos)
  in
    if column pos > 0
      then
        let
          before = T.take (column pos - 1) current
          after = T.drop (column pos) current
          rebuilt = replaceLine ls (line pos) [before <> after]
        in
          buffer
            { text = T.intercalate "\n" rebuilt
            , cursor = Cursor (Position (line pos) (column pos - 1))
            }
      else if line pos > 0
        then
          let
            previous = lineText ls (line pos - 1)
            merged = previous <> current
            rebuilt = replaceLine ls (line pos - 1) [merged]
          in
            buffer
              { text = T.intercalate "\n" (dropLine rebuilt (line pos))
              , cursor =
                  Cursor
                    (Position (line pos - 1) (T.length previous))
              }
        else
          buffer

move :: Direction -> Buffer -> Buffer
move direction buffer =
  let
    pos = position (cursor buffer)
    ls = T.lines (text buffer)
    current = lineText ls (line pos)
    lastLine = length ls - 1
  in
    case direction of
      Left'
        | column pos > 0 ->
            setPos buffer (Position (line pos) (column pos - 1))
        | line pos > 0 ->
            let previous = lineText ls (line pos - 1)
            in setPos buffer
              (Position (line pos - 1) (T.length previous))
        | otherwise ->
            buffer

      Right'
        | column pos < T.length current ->
            setPos buffer (Position (line pos) (column pos + 1))
        | line pos < lastLine ->
            setPos buffer (Position (line pos + 1) 0)
        | otherwise ->
            buffer

      Up
        | line pos > 0 ->
            let previous = lineText ls (line pos - 1)
            in setPos buffer
              (Position
                (line pos - 1)
                (min (column pos) (T.length previous)))
        | otherwise ->
            buffer

      Down
        | line pos < lastLine ->
            let next = lineText ls (line pos + 1)
            in setPos buffer
              (Position
                (line pos + 1)
                (min (column pos) (T.length next)))
        | otherwise ->
            buffer

moveLine :: Int -> Buffer -> Buffer
moveLine amount buffer =
  let
    pos = position (cursor buffer)
    ls = T.lines (text buffer)
    target = max 0 (min (length ls - 1) (line pos + amount))
    targetText = lineText ls target
  in
    setPos buffer
      (Position target (min (column pos) (T.length targetText)))

moveStart :: Buffer -> Buffer
moveStart buffer =
  let pos = position (cursor buffer)
  in setPos buffer (Position (line pos) 0)

moveEnd :: Buffer -> Buffer
moveEnd buffer =
  let
    pos = position (cursor buffer)
    ls = T.lines (text buffer)
    current = lineText ls (line pos)
  in setPos buffer
      (Position (line pos) (T.length current))

setPos :: Buffer -> Position -> Buffer
setPos buffer pos =
  buffer { cursor = Cursor pos }

lineText :: [Text] -> Int -> Text
lineText ls n =
  if n >= 0 && n < length ls
    then ls !! n
    else ""

replaceLine :: [Text] -> Int -> [Text] -> [Text]
replaceLine ls n replacement =
  take n ls <> replacement <> drop (n + 1) ls

dropLine :: [Text] -> Int -> [Text]
dropLine ls n =
  take n ls <> drop (n + 1) ls
