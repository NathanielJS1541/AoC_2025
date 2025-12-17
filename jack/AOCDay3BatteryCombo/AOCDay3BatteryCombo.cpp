
#include <iostream>
#include <string>
#include <vector>
#include <cstdint>
#include "day3.h"




int main()
{
    std::string pathway{ "input.txt" };

    std::vector<std::vector<std::uint16_t>> batteryBanks{ readAndParse(pathway) };
    int output1 = totalJoltage(batteryBanks);
    unsigned long long output2 = totalJoltagePart2(batteryBanks,12u);

    std::cout << output1 << " " << output2 << std::endl;

    return 0;
}
