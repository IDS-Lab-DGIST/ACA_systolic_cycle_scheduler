#pragma once

#include <vector>
#include <list>
#include <string>
#include <iostream>
#include <fstream>
#include <utility>
#include <memory>

#include "SystolicConfig.hpp"
#include "Layer.hpp"
#include "DNNs.hpp"
#include "DNNCycle.hpp"



class SystolicSimOS {
private:
    const std::string mName;
    const SystolicConfig mSystolicArrayConfig;
    const std::shared_ptr< std::vector<std::unique_ptr<DNN>>>& mDNNs;
    std::vector<DNNCycle> mLayerCycles;
    //const std::vector<long long> mTotalCycle;
    long long calculateLayer(Layer TargetLayer);
    long long TiledExecutionCycles(unsigned PartialSumHeight, unsigned TargetRow, unsigned TargetCol, unsigned FlushCycles , unsigned Iteration);
    void calculateDNN(void);
    void sumDNNcycles(void);


public:
    SystolicSimOS(std::string Name, SystolicConfig SystolicConfig,const std::shared_ptr< std::vector<std::unique_ptr<DNN>>>& DNNs);
    //void printSystolicConfig(void) const;
    void printSystolicConfig(void) const;
    void printLayerCycles(void) const;
    void printTotalCycle(void) const;

};
