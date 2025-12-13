#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include "UINT100.h"
#include "dayOne.h"

int main()
{
    UINT100 initialPosition{50};

    std::string pathway{ "input.txt" };
    std::vector<std::vector<unsigned int>> instructionList{readInstructions(pathway)};

    std::cout << "===========================================" << std::endl;
    std::cout << "part 1" << std::endl;
    std::cout << "===========================================" << std::endl;

    unsigned int passwordCount1{ crackPassword(instructionList,initialPosition) };

    std::cout << "===========================================" << std::endl;
    std::cout << "part 1" << std::endl;
    std::cout << "===========================================" << std::endl;
    unsigned int passwordCount2{ crackPasswordPart2(instructionList, initialPosition) };
    
    std::cout << "===========================================" << std::endl;
    std::cout << passwordCount1 << std::endl;
    std::cout << passwordCount2 << std::endl;

    return 0;
}

