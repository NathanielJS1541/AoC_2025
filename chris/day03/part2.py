#Python 3.10

joltage = 0 #Puzzle answer.

#For each line of input (without trailing newline).
for bank in open("input.txt").read().splitlines():
  biggestNum = "" #Largest number we can build in this bank.
  previousIndex = -1 #Index of previous biggest digit.
  
  #Count down from 11 to 0 inclusive.
  for n in range(11, -1, -1):
    #Define our search space. This ends at n digits from the end of the bank,
    #and starts after the previous biggest-digit found.
    substring = bank[previousIndex+1 : -n] if n>0 else bank[previousIndex+1 :]
    
    #Find the largest digit in this space and append it to the result.
    biggestDigit = max(substring)
    
    #Find the index of the first occurrence of this largest digit in this space.
    #Record that digit's index within the whole bank, not within the substring.
    previousIndex += substring.find(biggestDigit) + 1
    
    biggestNum += biggestDigit #Store this digit.
    
  joltage += int(biggestNum) #Add the biggest number found in the bank to the running total.

print(f"{joltage = }")
