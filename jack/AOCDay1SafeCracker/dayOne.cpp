#include "dayOne.h"

std::vector<std::vector<unsigned int>> readInstructions(std::string pathway) {

    std::ifstream instructionFile(pathway);

    std::vector<std::vector<unsigned int>> instructionList{};
    std::string currentInstruction{};

    while (std::getline(instructionFile, currentInstruction)) {
        std::vector<unsigned int> temp{};

        if (currentInstruction[0] == 'L') {
            temp.push_back(1u);
        }
        else {
            temp.push_back(0u);
        }
        currentInstruction.erase(0, 1);

        temp.push_back(std::stoul(currentInstruction));
        instructionList.push_back(temp);
    }
    return instructionList;
}

unsigned int crackPassword(std::vector<std::vector<unsigned int>> instructionList,UINT100 curPosition) {

    unsigned int passwordCount{0};

    for (auto rotation : instructionList) {
        if (rotation[0] == 0u) {
            curPosition += rotation[1];
        }
        else {
            curPosition -= rotation[1];
        }

        if (curPosition == 0) passwordCount++;
    }
    std::cout << curPosition << std::endl;
    return passwordCount;
}

unsigned int crackPasswordPart2(std::vector<std::vector<unsigned int>> instructionList, UINT100 oldPosition) {
    
    unsigned int passwordCount{ 0 };
    UINT100 newPosition{oldPosition};

    for (auto rotation : instructionList) {
        if (rotation[0] == 0u) {
            newPosition += rotation[1] % 100;
        }
        else {
            newPosition -= rotation[1] % 100;
        }

        passwordCount += checkClickCondition(oldPosition, rotation[1], rotation[0]);

        oldPosition = newPosition;
        
    }
    std::cout << oldPosition << std::endl;

    return passwordCount;
}

unsigned int checkClickCondition(UINT100 oldPosition,unsigned int fullClicks, unsigned int direction) {

    UINT100 partialClicks{fullClicks % 100};

    unsigned int overflowCounter{ fullClicks / 100 };
    

    if (direction == 0) {
        if (99u - oldPosition < partialClicks ) {
            overflowCounter++;
        }
    }
    else {
        if (oldPosition <= partialClicks) {
            overflowCounter++;
        }
    }


    return overflowCounter;
}