#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include "UINT100.h"
#include "dayOne.h"

int main()
{
    UINT100 initialPosition{50};

    std::string pathway{ "C:\\Users\\Jack\\Desktop\\Programming\\AdventOfCode\\AOCDay1SafeCracker\\input.txt" };
    std::vector<std::vector<unsigned int>> instructionList{readInstructions(pathway)};
    unsigned int passwordCount{ crackPassword(instructionList,initialPosition) };

    std::cout << passwordCount << std::endl;

    return 0;
}

