module Main where

data Tile = Ash | Rock
    deriving (Eq)

instance Show Tile where
    show Ash = "."
    show Rock = "#"

newtype Map = Map [[Tile]]

instance Show Map where
    show (Map m) = unlines . map showRow $ m
        where
            showRow :: [Tile] -> String
            showRow = concat . map show


data Mirror = Horizontal Int | Vertical Int | None
    deriving (Eq, Show)


parseInput :: String -> IO [Map]
parseInput path = do
    content <- readFile path
    let rows = lines content
    let maps = toMaps rows []
    return maps
    where
        toMaps :: [String] -> [Map] -> [Map]
        toMaps [] maps = maps
        toMaps (row:rows) [] = toMaps rows $ [Map [toTiles row]]
        toMaps ("":rows) maps = toMaps rows $ Map [] : maps
        toMaps (row:rows) (Map m:maps) = toMaps rows $ Map (m ++ [toTiles row]) : maps

        toTiles :: String -> [Tile]
        toTiles = map toTile

        toTile :: Char -> Tile
        toTile '.' = Ash
        toTile '#' = Rock
        toTile _ = error "Invalid tile"


transpose :: Map -> Map
transpose (Map []) = Map []
transpose (Map ([]:_)) = Map []
transpose (Map m) =
    let Map rest = transpose $ Map (map tail m)
    in Map $ (map head m) : rest


type CheckFn = [[Tile]] -> [[Tile]] -> Bool

findMirrorHorizontal :: CheckFn -> Map -> Maybe Int
findMirrorHorizontal f m = aux m (Map []) 0
    where
        aux (Map (row:rows)) (Map []) i = aux (Map rows) (Map [row]) (i + 1)
        aux (Map []) _ _ = Nothing
        aux (Map m1@(r1:rows1)) (Map m2@(r2:rows2)) i =
            if f m1 m2 then
                Just i
            else
                aux (Map rows1) (Map (r1:r2:rows2)) (i + 1)


findMirrorVertical :: CheckFn -> Map -> Maybe Int
findMirrorVertical f m1 = findMirrorHorizontal f $ transpose m1


findMirror :: CheckFn -> Map -> Mirror
findMirror f m =
    let x = maybe None (\y -> Horizontal y) $ findMirrorHorizontal f m
    in if x == None then
        maybe None (\y -> Vertical y) $ findMirrorVertical f m
    else
        x


findMirrors :: CheckFn -> [Map] -> [Mirror]
findMirrors _ [] = []
findMirrors f (m:ms) = findMirror f m : findMirrors f ms


calcValue :: [Mirror] -> Int
calcValue [] = 0
calcValue (m:ms) = case m of
    None -> 0
    Horizontal i -> i * 100 + calcValue ms
    Vertical i -> i + calcValue ms



-- Checks if 2 partitions of a map are mirror images of each other for part1
isMirrorImage :: CheckFn
isMirrorImage [] _ = True
isMirrorImage _ [] = True
isMirrorImage (t1:rows1) (t2:rows2) =
    t1 == t2 && isMirrorImage rows1 rows2


part1 :: [Map] -> Int
part1 input =
    let mirror = findMirrors isMirrorImage input
    in calcValue mirror


-- Checks if 2 partitions of a map are mirror images of each other except for
-- one "dirty" tile for part2
isDirtyMirrorImage :: CheckFn
isDirtyMirrorImage l r = aux l r 0
    where
        aux :: [[Tile]] -> [[Tile]] -> Int -> Bool
        aux [] _ n = n == 1
        aux _ [] n = n == 1
        aux (t1:rows1) (t2:rows2) n =
            let n' = n + aux2 t1 t2
            in if n' > 1 then
                False
            else
                aux rows1 rows2 n'

        aux2 :: [Tile] -> [Tile] -> Int
        aux2 [] _ = 0
        aux2 _ [] = 0
        aux2 (t1:rows1) (t2:rows2) =
            if t1 == t2 then
                aux2 rows1 rows2
            else
                1 + aux2 rows1 rows2


part2 :: [Map] -> Int
part2 input =
    let mirror = findMirrors isDirtyMirrorImage input
    in calcValue mirror


main :: IO ()
main = do
    input <- parseInput "input/input.txt"
    let value1 = part1 input
    print value1
    let value2 = part2 input
    print value2
