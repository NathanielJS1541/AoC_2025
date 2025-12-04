main :: IO ()

parseInstruction (dir, num) = (dir, read num)

instructions :: IO [(String, Integer)]
instructions = map (parseInstruction . splitAt 1) <$> (fmap lines . readFile) "input.txt"

rotate old (dir, num) c
  | dir == "L" = if old == 0 then bound (old - num) (c - 1) else bound (old - num) c
  | dir == "R" = do
      let (n, c0) = bound (old + num) c
      if n == 0 then (n,  c0 - 1) else (n, c0)
  | otherwise = error "bad instructions"

bound n c 
  | n < 0 = bound (100 + n) (c + 1) 
  | n > 99 = bound (n - 100) (c + 1) 
  | otherwise = (n, c)

solve (n, c) [] = c
solve (n, c) (i:is)
  | n == 0 = solve (rotate n i (c + 1)) is
  | otherwise = solve (rotate n i c) is

main = do
 insts <- instructions
 print (solve (50, 0) insts)


