#ifndef DAYONE_H
#define DAYONE_H

#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include "UINT100.h"
std::vector<std::vector<unsigned int>> readInstructions(std::string);
unsigned int crackPassword(std::vector<std::vector<unsigned int>>,UINT100);
unsigned int crackPasswordPart2(std::vector<std::vector<unsigned int>>, UINT100);
unsigned int checkClickCondition(UINT100, unsigned int,unsigned int);
#endif
