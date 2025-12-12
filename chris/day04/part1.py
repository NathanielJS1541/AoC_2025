#Python 3.10

#Read input diagram into list, without trailing newlines.
grid = open("input.txt").read().splitlines()

#Coordinates of 8 adjacent positions relative to center position.
xDirs = [-1,  0,  1, -1, 1, -1, 0, 1]
yDirs = [-1, -1, -1,  0, 0,  1, 1, 1]

numAccessibleRolls = 0 #Puzzle answer.

for y, row in enumerate(grid): #For each row in diagram.
  for x, char in enumerate(row): #For each column (i.e. character) in row.
  
    if char != "@": continue #Skip this coordinate if it's not paper.
    
    numRollsAround = 0 #Number of adjacent paper rolls.
    
    for n in range(8): #For each of the 8 adjacent positions.
      
      #Skip it if it's outside of the grid.
      if (dX := x + xDirs[n]) < 0 or dX >= len(row): continue
      if (dY := y + yDirs[n]) < 0 or dY >= len(grid): continue
      
      if grid[dY][dX] == "@": #Check if it's a paper roll.
        numRollsAround += 1

    if numRollsAround < 4:
      numAccessibleRolls += 1  

print(f"{numAccessibleRolls = }")
