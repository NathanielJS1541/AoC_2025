#Python 3.10

#Split input by comma, then again by dash, into list of list[str,str].
ranges = [r.split('-') for r in open("input.txt").readline().rstrip().split(',')]

#Replace each sub-list with a sequence of numbers between its start and end values (inclusive).
ranges = [range(int(r[0]), int(r[1]) + 1) for r in ranges]

sumInvalid = 0 #Puzzle answer.

#For each product ID.
for r in ranges:
  for i in r:    
    s = str(i) #Convert ID to string.
    
    #If first half of string matches second half.
    if s[:int(len(s)/2)] == s[int(len(s)/2):]:
      #Then ID is invalid.
      sumInvalid += i
    
print(f"{sumInvalid = }")
