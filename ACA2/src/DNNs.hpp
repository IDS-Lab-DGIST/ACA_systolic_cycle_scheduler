#pragma once
#include <vector>
#include <utility>
#include "Layer.hpp"


class DNN {
private:
    std::string mDNNName;
    std::vector<Layer> mDNNLayers;

public:
    DNN( std::string DNNname)
        :mDNNName(DNNname),
        mDNNLayers(std::vector<Layer>())
    {
    }

    void setDNNLayer(Layer DNNLayer)
    {
        mDNNLayers.push_back(DNNLayer);
    }

    
    std::vector<Layer> getDNNLayer(void)
    {
        return mDNNLayers;
    }

    std::string getName(void){
        return mDNNName;
    }

    void printLayer(void)
    {
        std::cout<<"DNN name : "<<mDNNName<<std::endl;
        for(auto iter = mDNNLayers.begin(); iter != mDNNLayers.end(); iter++){
            (*iter).print();
        }
    }


};