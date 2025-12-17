#ifndef DAYTHREE_H
#define DAYTHREE_H

#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <cstdint>

std::vector<std::vector<std::uint16_t>> readAndParse(std::string);
int totalJoltage(std::vector<std::vector<std::uint16_t>>);
unsigned long long totalJoltagePart2(std::vector<std::vector<std::uint16_t>>,int cells);

#endif