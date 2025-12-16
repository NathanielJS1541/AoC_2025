#include <iostream>
#include <vector>
#include <string>
#include "day2.h"



int main()
{
    std::string pathway{ "input.txt" };

    std::vector<std::vector<long long>> ranges{readAndParseInputFile(pathway)};
    //long long invalidEntries{checkForRepeats(ranges)};
    long long invalidEntriesPart2{ checkForRepeatsPart2(ranges) };
    std::cout << " " << invalidEntriesPart2 << std::endl;

    return 0;
}


