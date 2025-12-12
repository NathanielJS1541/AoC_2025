#Python 3.10

#This code scares me because I'm modifying the input list while
#iterating over it and yet somehow get the correct answer...
#Is it possible that it doesn't make a difference whether you remove
#the rolls a bunch at a time, like in the AoC example, or one by one??

#Read input diagram into 2D list of characters.
grid = [list(line) for line in open("input.txt").read().splitlines()]

#Coordinates of 8 adjacent positions relative to center position.
xDirs = [-1,  0,  1, -1, 1, -1, 0, 1]
yDirs = [-1, -1, -1,  0, 0,  1, 1, 1]

numRollsRemoved = 0 #Puzzle answer.

while True:
  
  anyRollsRemoved = False #Any rolls removed during this iteration?

  for y, row in enumerate(grid): #For each row in diagram.
    for x, char in enumerate(row): #For each column (i.e. character) in row.
    
      if char != "@": continue #Skip this coordinate if it's not paper.
      
      numRollsAround = 0 #Number of adjacent paper rolls.
      
      for n in range(8): #For each of the 8 adjacent positions.
        
        #Ignore it if it's outside of the grid.
        if (dX := x + xDirs[n]) < 0 or dX >= len(row): continue
        if (dY := y + yDirs[n]) < 0 or dY >= len(grid): continue
        
        if grid[dY][dX] == "@": #Check if it contains a paper roll.
          numRollsAround += 1
  
      if numRollsAround < 4: #Roll at this position can be removed.
        grid[y][x] = "."
        numRollsRemoved += 1
        anyRollsRemoved = True
  
  if not anyRollsRemoved: break #Exit while loop.
  
print(f"{numRollsRemoved = }")
