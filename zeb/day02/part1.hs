main :: IO ()

-- parse the input
splitC f "" = []
splitC f s = w : splitC f ss'
  where
    (w, ss) = break f s
    ss' = if ss == "" then [] else tail ss

idRangesIo = splitC (==',') . init <$> readFile "input.txt"

pairRange [x, y] = [read x..read y]

rangesToList :: [String] -> [Integer]
rangesToList = concatMap (pairRange . splitC (== '-'))

-- solve the problem
pairMatch (x, y) = x == y

checkInvalid id
  | even (length id) = pairMatch (splitAt (quot (length id) 2) id)
  | otherwise = False

sumInvalid [] c = c
sumInvalid (id:ids) c
  | checkInvalid (show id) = sumInvalid ids c + id
  | otherwise = sumInvalid ids c
  
main = do
 idRanges <- idRangesIo
 print (sumInvalid (rangesToList idRanges) 0)

