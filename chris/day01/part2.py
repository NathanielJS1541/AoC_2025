#Python 3.8

#Read input into list of str.
input = open("input.txt").readlines()

#Convert to positive/negative ints: L50 to -50, R20 to 20, etc.
input = [-int(i[1:]) if i[0] == 'L' else int(i[1:]) for i in input]

d = 50 #Dial value.
ld = 50 #Last dial value.
numZeroes = 0 #Puzzle answer.

for i in input:
    d += i
    
    dir = -1 if i < 0 else 1 #Sign of input value.
    #Generate a sequence of numbers between the last dial value and the new one.
    #Exclude the previous dial value and include the new value.
    #Count the number of zeroes or multiples of 100 within that range. Jank alert.
    numZeroes += sum(abs(x) % 100 == 0 for x in range(ld, d + dir, dir)[1:])

    ld = d

print(f"{numZeroes = }") #Woah self-documenting f-string.
