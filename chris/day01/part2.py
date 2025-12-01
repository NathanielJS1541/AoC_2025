#Python 3.8

#Read input into list of str.
input = open("input.txt").readlines()

#Convert to positive/negative ints: L50 to -50, R20 to 20, etc.
input = [-int(i[1:]) if i[0] == 'L' else int(i[1:]) for i in input]

d = 50 #Current dial value.
ld = None #Last dial value.
numZeroes = 0 #Puzzle answer.

for i in input:
    d += i #Rotate dial.
    
    #Count number of rotations through 0.
    if ld != None:
        #Generate a sequence of numbers between the last dial value and the new one.
        #Count the number of zeroes or multiples of 100 in that range. Jank alert.
        numZeroes += sum(abs(x) % 100 == 0 for x in range(ld, d, 1 if d > ld else -1)[1:])
    
    ld = d
        
    #If new value is 0 or multiple of 100.
    if abs(d) % 100 == 0:
        numZeroes += 1

print(f"{numZeroes = }") #Woah self-documenting f-string.
