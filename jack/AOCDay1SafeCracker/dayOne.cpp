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

    return passwordCount;
}