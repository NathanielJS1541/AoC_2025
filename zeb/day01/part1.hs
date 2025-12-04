main :: IO ()

parseInstruction (dir, num) = (dir, read num)

instructions :: IO [(String, Integer)]
instructions = map (parseInstruction . splitAt 1) <$> (fmap lines . readFile) "input.txt"

rotate old (dir, num)
  | dir == "L" = bound (old - num)
  | otherwise = bound (old + num)

bound n
  | n < 0 = bound (100 + n)
  | n > 99 = bound (n - 100)
  | otherwise = n

solve n c [] = c
solve n c (i:is)
  | n == 0 = solve (rotate n i) (c + 1) is
  | otherwise = solve (rotate n i) c is

main = do
 insts <- instructions
 print (solve 50 0 insts)


