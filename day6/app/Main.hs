module Main where

import Data.List
import Data.Maybe
import Data.Set as Set hiding (drop, findIndex, foldl, map, take)
import Debug.Trace
import System.IO

main :: IO ()
main = do
  input <- parseInput "input.txt"
  let guardPosition = fromJust (getCurrGuardPosition input)
  let guard = fromJust (getCharAtIndex input guardPosition)
  let guardDirection = fromJust (getGuardDirection guard)
  let lines = removeGuard input guardPosition
  let moveCounter = moveGuardUntilOutside lines guardPosition guardDirection []
  print (countUniquePositions moveCounter)

foldli :: (b -> a -> Int -> b) -> b -> [a] -> b
foldli f acc xs = snd $ foldl (\(i, acc) x -> (i + 1, f acc x i)) (0, acc) xs

parseInput :: String -> IO [[Char]]
parseInput filePath = do
  contents <- readFile filePath
  return (lines contents)

getCurrGuardPosition :: [[Char]] -> Maybe (Int, Int)
getCurrGuardPosition =
  foldli
    ( \acc line i -> case getCurrGuardColumn line of
        Just j -> Just (i, j)
        Nothing -> acc
    )
    Nothing

getCurrGuardColumn :: [Char] -> Maybe Int
getCurrGuardColumn = findIndex isGuard

isGuard :: Char -> Bool
isGuard char = char == '^' || char == 'v' || char == '<' || char == '>'

data Direction = DUp | DDown | DLeft | DRight

getGuardDirection :: Char -> Maybe Direction
getGuardDirection char = case char of
  '^' -> Just DUp
  'v' -> Just DDown
  '<' -> Just DLeft
  '>' -> Just DRight
  _ -> Nothing

getCharAtIndex :: [[Char]] -> (Int, Int) -> Maybe Char
getCharAtIndex lines (i, j)
  | i < 0 || i >= length lines = Nothing
  | j < 0 || j >= length (lines !! i) = Nothing
  | otherwise = Just ((lines !! i) !! j)

isCharAtIndexObstacle :: [[Char]] -> (Int, Int) -> Bool
isCharAtIndexObstacle lines (i, j) = case getCharAtIndex lines (i, j) of
  Just char -> char == '#'
  Nothing -> False

canGuardMoveUp :: [[Char]] -> (Int, Int) -> Bool
canGuardMoveUp lines (i, j) = not (isCharAtIndexObstacle lines (i - 1, j))

canGuardMoveDown :: [[Char]] -> (Int, Int) -> Bool
canGuardMoveDown lines (i, j) = not (isCharAtIndexObstacle lines (i + 1, j))

canGuardMoveLeft :: [[Char]] -> (Int, Int) -> Bool
canGuardMoveLeft lines (i, j) = not (isCharAtIndexObstacle lines (i, j - 1))

canGuardMoveRight :: [[Char]] -> (Int, Int) -> Bool
canGuardMoveRight lines (i, j) = not (isCharAtIndexObstacle lines (i, j + 1))

getGuardNextPosition :: [[Char]] -> (Int, Int) -> Direction -> ((Int, Int), Direction)
getGuardNextPosition lines (i, j) direction = case direction of
  DUp -> if canGuardMoveUp lines (i, j) then ((i - 1, j), DUp) else ((i, j + 1), DRight)
  DDown -> if canGuardMoveDown lines (i, j) then ((i + 1, j), DDown) else ((i, j - 1), DLeft)
  DLeft -> if canGuardMoveLeft lines (i, j) then ((i, j - 1), DLeft) else ((i - 1, j), DUp)
  DRight -> if canGuardMoveRight lines (i, j) then ((i, j + 1), DRight) else ((i + 1, j), DDown)

isGuardOutside :: [[Char]] -> (Int, Int) -> Bool
isGuardOutside lines (i, j) = i < 0 || i >= length lines || j < 0 || j >= length (lines !! i)

removeGuard :: [[Char]] -> (Int, Int) -> [[Char]]
removeGuard lines (i, j) = take i lines ++ [take j (lines !! i) ++ "." ++ drop (j + 1) (lines !! i)] ++ drop (i + 1) lines

moveGuardUntilOutside :: [[Char]] -> (Int, Int) -> Direction -> [(Int, Int)] -> [(Int, Int)]
moveGuardUntilOutside lines (i, j) direction history =
  trace ("Guard at position: " ++ show (i, j)) $
    let newHistory = history ++ [(i, j)]
     in if isGuardOutside lines (i, j)
          then history
          else
            let (nextPosition, nextDirection) = getGuardNextPosition lines (i, j) direction
             in moveGuardUntilOutside lines nextPosition nextDirection newHistory

countUniquePositions :: [(Int, Int)] -> Int
countUniquePositions xs = Set.size (Set.fromList xs)
