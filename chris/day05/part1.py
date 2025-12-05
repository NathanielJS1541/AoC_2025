#Python 3.10

freshRanges = []
numFresh = 0 #Puzzle answer.

#For each line of input.
for line in open("input.txt").read().splitlines():
  if "-" in line: #Line is a range.
    #Store that range.
    freshRanges.append(range(int(line.split("-")[0]), int(line.split("-")[1]) + 1))
  
  elif line: #Line is an ID.
    if any(int(line) in r for r in freshRanges): #If the ID is in any of the ranges.
      numFresh += 1
      
print(f"{numFresh = }")
