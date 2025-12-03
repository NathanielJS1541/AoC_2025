#Python 3.10

#Oh my goodness a one-liner and it's hideous.
print(f"joltage = {sum(int(max(s[:-1]) + max(s[s[:-1].find(max(s[:-1]))+1:])) for s in open('input.txt').read().splitlines())}")


#And now the more sensible version:

joltage = 0 #Puzzle answer.

#For each line of input (without trailing newline).
for bank in open("input.txt").read().splitlines():
  
  #Find the largest digit that isn't the last digit.
  firstDigit = max(bank[:-1])
  
  #Get the index of the first occurrence of this digit.
  indexOfFirstDigit = bank[:-1].find(firstDigit)
  
  #Find the largest digit to the right of that.
  secondDigit = max(bank[indexOfFirstDigit+1:])
  
  #Combine the two digits.
  biggestNum = int(firstDigit + secondDigit)
  
  joltage += biggestNum #Add it to the total.

print(f"{joltage = }")
