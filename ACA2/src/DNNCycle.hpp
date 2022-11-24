#pragma once
#include <vector>
#include <utility>
#include "Layer.hpp"


class DNNCycle {
private:
    std::string mDNNName;
    std::vector<long long>mCycles;
    long long mTotalCycle;

public:
    DNNCycle( std::string DNNname)
        :mDNNName(DNNname),
        mCycles(std::vector<long long>()),
        mTotalCycle(0)        
    {

    }

    void setDNNCycle(long long cycle)
    {
        mCycles.push_back(cycle);
    }
    

    std::string getName(void){
        return mDNNName;
    }

    void sumTotalCycle(void){
        for(auto Cycle = mCycles.begin(); Cycle != mCycles.end(); Cycle++){
            mTotalCycle += (*Cycle);
        }
    }

    void printCycle(void) const
    {
        std::cout<<"DNN name : "<<mDNNName<<std::endl;
        for(auto iter = mCycles.begin(); iter != mCycles.end(); iter++){
            std::cout<<*iter<<" ";
        }
        std::cout<<std::endl;
    }
    
    void printTotalCycle(void) const
    {
        std::cout<<"DNN name : "<<mDNNName<<std::endl;
        std::cout<<"Total cycle : "<<mTotalCycle<<std::endl;

    }


};