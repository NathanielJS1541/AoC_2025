main :: IO ()

-- parse the input
splitC f "" = []
splitC f s = w : splitC f ss'
  where
    (w, ss) = break f s
    ss' = if ss == "" then [] else drop 1 ss

idRangesIo = splitC (==',') . init <$> readFile "input.txt"

pairRange [x, y] = [read x..read y]

rangesToList = concatMap (pairRange . splitC (== '-'))

-- solve the problem
pairMatch (x, y) = x == y

splitN i [] = []
splitN i s = w : splitN i ss
  where
    (w, ss) = splitAt i s

allEqual (x:xs) = all (== x) xs

checkInvalid :: Int -> String -> Bool
checkInvalid i id
  | i <= quot (length id) 2 = allEqual (splitN i id) || checkInvalid (i+1) id
  | otherwise = False

sumInvalid [] c = c
sumInvalid (id:ids) c
  | checkInvalid 1 (show id) = sumInvalid ids c + id
  | otherwise = sumInvalid ids c

main = do
  idRanges <- idRangesIo
  print (splitN 3 "abcdefg")
  print (allEqual [1, 1, 1, 1, 1])
  print (sumInvalid (rangesToList idRanges) 0)

