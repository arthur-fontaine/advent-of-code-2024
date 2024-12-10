module Main where

import Data.List
import Data.Maybe
import Data.Set as Set hiding (drop, filter, findIndex, foldl, foldr, map, take)
import System.Environment

main :: IO ()
main = do
  input <- parseInput "input.txt"
  args <- getArgs

  let result = case args of
        ["part1"] -> part1 input
        ["part2"] -> part2 input
        _ -> error "invalid argument"

  print result

part1 :: [[Char]] -> Int
part1 input = do
  let guardPosition = fromJust (getCurrGuardPosition input)
      guard = fromJust (getCharAtIndex input guardPosition)
      guardDirection = fromJust (getGuardDirection guard)
  let rows = removeGuard input guardPosition
  let history = moveGuardUntilOutside rows guardPosition guardDirection []
  countUniquePositions history

part2 :: [[Char]] -> Int
part2 input = do
  let possibleNewInputs = placeObstacles input
  let numberOfLooping = length (filteri isLooping' possibleNewInputs)
  numberOfLooping
  where
    isLooping' :: [[Char]] -> Int -> Bool
    isLooping' rows _ =
      let guardPosition = fromJust (getCurrGuardPosition rows)
          guard = fromJust (getCharAtIndex rows guardPosition)
          guardDirection = fromJust (getGuardDirection guard)
          linesWithoutGuard = removeGuard rows guardPosition
       in isLooping linesWithoutGuard guardPosition guardDirection Set.empty

foldli :: (b -> a -> Int -> b) -> b -> [a] -> b
foldli f acc xs = snd $ foldl (\(i, accu) x -> (i + 1, f accu x i)) (0, acc) xs

filteri :: (a -> Int -> Bool) -> [a] -> [a]
filteri f = foldli (\acc x i -> if f x i then acc ++ [x] else acc) []

parseInput :: String -> IO [[Char]]
parseInput filePath = do
  contents <- readFile filePath
  return (lines contents)

getCurrGuardPosition :: [[Char]] -> Maybe (Int, Int)
getCurrGuardPosition =
  getCurrGuardPosition' 0
  where
    getCurrGuardPosition' :: Int -> [[Char]] -> Maybe (Int, Int)
    getCurrGuardPosition' _ [] = Nothing
    getCurrGuardPosition' i (line : rows) =
      case getCurrGuardColumn line of
        Just j -> Just (i, j)
        Nothing -> getCurrGuardPosition' (i + 1) rows

getCurrGuardColumn :: [Char] -> Maybe Int
getCurrGuardColumn = findIndex isGuard

isGuard :: Char -> Bool
isGuard char = char == '^' || char == 'v' || char == '<' || char == '>'

data Direction = DUp | DDown | DLeft | DRight deriving (Eq, Show, Ord)

getGuardDirection :: Char -> Maybe Direction
getGuardDirection char = case char of
  '^' -> Just DUp
  'v' -> Just DDown
  '<' -> Just DLeft
  '>' -> Just DRight
  _ -> Nothing

getCharAtIndex :: [[Char]] -> (Int, Int) -> Maybe Char
getCharAtIndex rows (i, j)
  | i < 0 || i >= length rows = Nothing
  | j < 0 || j >= length (rows !! i) = Nothing
  | otherwise = Just ((rows !! i) !! j)

isCharAtIndexObstacle :: [[Char]] -> (Int, Int) -> Bool
isCharAtIndexObstacle rows (i, j) = case getCharAtIndex rows (i, j) of
  Just char -> char == '#'
  Nothing -> False

canGuardMoveUp :: [[Char]] -> (Int, Int) -> Bool
canGuardMoveUp rows (i, j) = not (isCharAtIndexObstacle rows (i - 1, j))

canGuardMoveDown :: [[Char]] -> (Int, Int) -> Bool
canGuardMoveDown rows (i, j) = not (isCharAtIndexObstacle rows (i + 1, j))

canGuardMoveLeft :: [[Char]] -> (Int, Int) -> Bool
canGuardMoveLeft rows (i, j) = not (isCharAtIndexObstacle rows (i, j - 1))

canGuardMoveRight :: [[Char]] -> (Int, Int) -> Bool
canGuardMoveRight rows (i, j) = not (isCharAtIndexObstacle rows (i, j + 1))

getGuardNextPosition :: [[Char]] -> (Int, Int) -> Direction -> ((Int, Int), Direction)
getGuardNextPosition rows (i, j) direction = case direction of
  DUp -> if canGuardMoveUp rows (i, j) then ((i - 1, j), DUp) else getGuardNextPosition rows (i, j) DRight
  DDown -> if canGuardMoveDown rows (i, j) then ((i + 1, j), DDown) else getGuardNextPosition rows (i, j) DLeft
  DLeft -> if canGuardMoveLeft rows (i, j) then ((i, j - 1), DLeft) else getGuardNextPosition rows (i, j) DUp
  DRight -> if canGuardMoveRight rows (i, j) then ((i, j + 1), DRight) else getGuardNextPosition rows (i, j) DDown

isGuardOutside :: [[Char]] -> (Int, Int) -> Bool
isGuardOutside rows (i, j) = i < 0 || i >= length rows || j < 0 || j >= length (rows !! i)

removeGuard :: [[Char]] -> (Int, Int) -> [[Char]]
removeGuard rows (i, j) = take i rows ++ [take j (rows !! i) ++ "." ++ drop (j + 1) (rows !! i)] ++ drop (i + 1) rows

isLooping :: [[Char]] -> (Int, Int) -> Direction -> Set ((Int, Int), Direction) -> Bool
isLooping rows (i, j) direction history =
  if isGuardOutside rows (i, j)
    then False
    else
      if isPositionAlreadyInHistory history ((i, j), direction)
        then True
        else
          let (nextPosition, nextDirection) = getGuardNextPosition rows (i, j) direction
           in isLooping rows nextPosition nextDirection (Set.insert ((i, j), direction) history)

isPositionAlreadyInHistory :: Set ((Int, Int), Direction) -> ((Int, Int), Direction) -> Bool
isPositionAlreadyInHistory history position = Set.member position history

countUniquePositions :: [(Int, Int)] -> Int
countUniquePositions xs = Set.size (Set.fromList xs)

moveGuardUntilOutside :: [[Char]] -> (Int, Int) -> Direction -> [(Int, Int)] -> [(Int, Int)]
moveGuardUntilOutside rows (i, j) direction history =
  let newHistory = history ++ [(i, j)]
   in if isGuardOutside rows (i, j)
        then history
        else
          let (nextPosition, nextDirection) = getGuardNextPosition rows (i, j) direction
           in moveGuardUntilOutside rows nextPosition nextDirection newHistory

placeObstacles :: [[Char]] -> [[[Char]]]
placeObstacles input = do
  let guardPosition = fromJust (getCurrGuardPosition input)
  let guard = fromJust (getCharAtIndex input guardPosition)
  let guardDirection = fromJust (getGuardDirection guard)
  let visited = moveGuardUntilOutside input guardPosition guardDirection []
  [ replaceAtIndex i j '#' input
    | i <- [0 .. length input - 1],
      j <- [0 .. length (input !! i) - 1],
      (input !! i !! j == '.') && elem (i, j) visited
    ]

replaceAtIndex :: Int -> Int -> Char -> [[Char]] -> [[Char]]
replaceAtIndex row col char matrix =
  take row matrix
    ++ [take col (matrix !! row) ++ [char] ++ drop (col + 1) (matrix !! row)]
    ++ drop (row + 1) matrix
