#ifndef DAYTWO_H
#define DAYTWO_H

#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>

std::vector<std::vector<long long>> readAndParseInputFile(std::string);
bool invalidCheck(long long);
long long checkForRepeats(std::vector<std::vector<long long>>);
bool invalidCheckPart2(long long);
long long checkForRepeatsPart2(std::vector<std::vector<long long>>);

#endif
