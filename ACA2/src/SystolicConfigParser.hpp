#pragma once

#include <fstream>
#include <iostream>
#include <vector>

#include "SystolicConfig.hpp"

class SystolicConfigParser {
private:
    std::string mSystolicConfigTextName;
    std::vector<SystolicConfig> mSystolicConfigVector;

public:

    SystolicConfigParser(std::string SystolicConfigTextName)
        :mSystolicConfigTextName(SystolicConfigTextName)
    {
        std::string line;
        //std::string delimiterSpace = " ";    
        mSystolicConfigVector.reserve(3);

        std::fstream fin;
        fin.open(mSystolicConfigTextName);
        
        std::string first;
        std::string second;
        std::string third;

        while(fin>>first>>second>>third)
        {
            /*
            std::cout<<"Frist : "<<first<<std::endl;
            std::cout<<"Second : "<<second<<std::endl;
            std::cout<<"Third : "<<third<<std::endl;
            */
            SystolicConfig temporalConfig = { static_cast<unsigned>(std::stoi(first)), static_cast<unsigned>(std::stoi(second)) };

           mSystolicConfigVector.push_back(temporalConfig);
        }


        fin.close();
    }

    void printSystolicconfig(void) const {
        
        //std::cout<<"Systolic configuration"<<std::endl;
        for(auto iter = mSystolicConfigVector.begin(); iter != mSystolicConfigVector.end(); iter++)
        {
            std::cout<<"Systolic config row : "<<(*iter).Row<<std::endl;
            std::cout<<"Systolic config col : "<<(*iter).Col<<std::endl;
        }
        
    }

    SystolicConfig getFristConfig(void) const {
        return mSystolicConfigVector[0];
    }

    SystolicConfig getSecondConfig(void) const {
        return mSystolicConfigVector[1];
    }

    SystolicConfig getThirdConfig(void) const {
        return mSystolicConfigVector[2];
    }
};