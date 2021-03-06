{-# LANGUAGE TupleSections #-}

module TicTacToe where

import           Types
import qualified Data.Map as Map

-- useful helper functions and variables
other :: Piece -> Piece
other X = O
other O = X

legal :: [Int]
legal = [1, 2, 3]

emptyBoard :: Board
emptyBoard = Map.empty

winningPositions :: [[Position]]
winningPositions = [map (1,) legal, -- first three are vertical
                    map (2,) legal,
                    map (3,) legal,
                    map (,1) legal, -- next three are horizontal
                    map (,2) legal,
                    map (,3) legal,
                    map (\x -> (x, x)) legal, -- last two are diagonal
                    [(x, y) | x <- legal, y <- legal, x + y == 4]]

-- game logic
win :: Board -> Piece -> Bool
win board piece = any (threeInARow board piece) winningPositions

threeInARow :: Board -> Piece -> [Position] -> Bool
threeInARow board piece lane = all (== Just piece) [Map.lookup spot board
                                                   | spot <- lane]

draw :: Board -> Bool
draw board = Map.size board == 9 && not (win board X) && not (win board O)

gameOver :: Board -> Maybe String
gameOver board
  | win board X = Just "\nPlayer X wins!"
  | win board O = Just "\nPlayer O wins!"
  | draw board = Just "\nCat's Game."
  | otherwise = Nothing

makeMove :: Board -> Piece -> Maybe Position -> Either YourError Board
makeMove _ _ Nothing = Left BadInput
makeMove board piece (Just (x, y)) =
  if x `notElem` legal || y `notElem` legal
  then Left OutOfBounds
  else case Map.lookup (x, y) board of
    Just _ -> Left NonEmptySquare
    Nothing -> Right $ Map.insert (x, y) piece board
