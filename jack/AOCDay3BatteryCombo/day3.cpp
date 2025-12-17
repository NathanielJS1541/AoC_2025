#include "day3.h"

std::vector<std::vector<std::uint16_t>> readAndParse(std::string path) {

    std::ifstream fileData(path);

    std::string bankData{};
    std::vector<std::vector<std::uint16_t>> banks{};

    while (std::getline(fileData, bankData)) {

        std::vector<std::uint16_t> tempHolder{};

        for (auto battery : bankData) {

            uint16_t x = static_cast<uint16_t>(battery) - 48u;
            tempHolder.push_back(x);
        }

        banks.push_back(tempHolder);
    }

    return banks;
}

int totalJoltage(std::vector<std::vector<std::uint16_t>> banks) {

    int total{ 0 };

    for (auto bank : banks) {

        std::uint16_t best{ 0u };
        std::uint16_t secondBest{ 0u };

        for (int i = 0; i < bank.size(); i++) {

            std::uint16_t battery = bank[i];

            if (i != bank.size() - 1) { if (battery > best) { best = battery; secondBest = 0u; continue; } }
            if (battery > secondBest) { secondBest = battery; continue; }
        }

        total += (best * 10 + secondBest);
    }

    return total;
}

unsigned long long totalJoltagePart2(std::vector<std::vector<std::uint16_t>> banks,int cells) {
    
    unsigned long long totalTotal{ 0 };

    for (auto bank : banks) {

        std::vector < std::uint16_t > batteryValues(cells,0u);
        std::uint16_t startIndex{ 0 };

        for (int i = 0; i < bank.size(); i++) {

            std::uint16_t battery{ bank[i] } ;

            if (i > bank.size() - cells) {
                startIndex++;
            }



            for (int j = startIndex; j < cells; j++) {

 

                if (batteryValues[j] < battery) {

                    batteryValues[j] = battery;

                    for(int k = j+1; k < cells; k++){
                        
                        batteryValues[k] = 0;
                        
                    }

                    break;
                }

            }          
        }

        unsigned long long total{ 0 };

        for (int i = 0; i < cells; i++) {

            unsigned long long exp{ 1 };

            for (int j = 0; j < cells - (i + 1); j++) {
                exp *= 10;
            }

            total += batteryValues[i] * exp ;

        }

        totalTotal += total;

    }

    return totalTotal;
}