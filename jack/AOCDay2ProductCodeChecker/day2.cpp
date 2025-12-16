#include "day2.h"

std::vector<std::vector<long long>> readAndParseInputFile(std::string pathway) {

    std::ifstream rangeData(pathway);

    std::string tempS{};
    std::getline(rangeData, tempS);

    std::stringstream ss(tempS);
    std::string curToken{};
    std::vector<std::vector<long long>> ranges{};

    while (std::getline(ss, curToken, ',')) {

        std::string tempS{};
        std::stringstream tempSS(curToken);
        std::vector<long long> range{};

        while (std::getline(tempSS, tempS, '-')) {
            long long x = stoll(tempS);
            range.push_back(x);
        }
        ranges.push_back(range);
    }

    return ranges;
}

bool invalidCheck(long long i) {

    std::string tempS = std::to_string(i);

    if (tempS.length() % 2 == 0) {

        return tempS.substr(0, tempS.length() / 2) == tempS.substr(tempS.length() / 2, tempS.length() / 2);

    }

    return false;
}

long long checkForRepeats(std::vector<std::vector<long long>> productCodeRanges) {

    long long invalidEntries{ 0 };

    for (auto limits : productCodeRanges) {

        for (long long i = limits[0]; i <= limits[1]; i++) {

            if (invalidCheck(i)) {
                invalidEntries += i;
            }
        }
    }

    return invalidEntries;

}

bool invalidCheckPart2(long long checkInt) {

    std::string tempS = std::to_string(checkInt);

    for (int i = 1; i <= tempS.length() / 2; i++) {

        if (tempS.length() % i == 0) {

            std::string tileStr{ tempS.substr(0,i) };

            std::string checkStr{};

            for (int j = 0; j < tempS.length() / i; j++) checkStr += tileStr;

            if (checkStr == tempS) return true;
        }  
    }


    return false;
}

long long checkForRepeatsPart2(std::vector<std::vector<long long>> productCodeRanges) {

    long long invalidEntries{ 0 };

    for (auto limits : productCodeRanges) {

        for (long long i = limits[0]; i <= limits[1]; i++) {

            if (invalidCheckPart2(i)) {
                invalidEntries += i;
            }
        }
    }

    return invalidEntries;

}
