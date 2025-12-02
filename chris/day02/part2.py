#Python 3.10

import re #Regex.

#Split input string by comma, then again by dash, into list of list[str,str].
ranges = [r.split('-') for r in open("input.txt").readline().rstrip().split(',')]

#Replace each sub-list with a sequence of numbers between its start and end values (inclusive).
ranges = [range(int(r[0]), int(r[1]) + 1) for r in ranges]

sumInvalid = 0 #Puzzle answer.

#For each product ID.
for r in ranges:
  for i in r:
    #Check if the whole ID is composed of a group of one or more digits that repeats two or more times.
    if re.search(r"^(\d+)\1+$", str(i)):
      #Therefore ID is invalid.
      sumInvalid += i

print(f"{sumInvalid = }")
