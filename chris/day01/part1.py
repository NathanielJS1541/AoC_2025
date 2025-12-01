#Python 3.8

#Read input into list of str.
input = open("input.txt").readlines()

#Convert to positive/negative int: L50 to -50, R20 to 20, etc.
input = [-int(i[1:]) if i[0] == 'L' else int(i[1:]) for i in input]

d = 50 #Dial value.
numZeroes = 0 #Puzzle answer.

for i in input:
    d += i
    #If new value is multiple of 100.
    if abs(d) % 100 == 0:
        numZeroes += 1
    
print(f"{numZeroes = }") #Woah self-documenting f-string.
