
#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <cstdint>


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

        for (int i = 0; i < bank.size();i++) {

            std::uint16_t battery = bank[i];

            if(i != bank.size()-1){ if (battery > best) { best = battery; secondBest = 0u; continue; } }
            if (battery > secondBest) { secondBest = battery; continue; }
        }

        std::cout << best << " " << secondBest << std::endl;
        total += (best * 10 + secondBest);
    }

    return total;
}

int main()
{
    std::string pathway{ "input.txt" };

    std::vector<std::vector<std::uint16_t>> batteryBanks{ readAndParse(pathway) };
    int output = totalJoltage(batteryBanks);

    std::cout << output << std::endl;

}
