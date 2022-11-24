#pragma once

#include <string>
#include <iomanip>

class Layer{
public:
    std::string LayerName;
    unsigned IterN;
    unsigned InputRow;
    unsigned InputCol;
    unsigned WeightRow;
    unsigned WeightCol;
    unsigned OutputRow;
    unsigned OutputCol;

    void Empty(void)
    {
        LayerName="";
        IterN = 0;
        InputRow = 0;
        InputCol = 0;
        WeightRow = 0;
        WeightCol = 0;
        OutputRow = 0;
        OutputCol = 0;
    }
    
    void print(void) const
    {
        std::cout<<"Layer name : "<<LayerName<<std::endl;
        std::cout<<std::setw(20)<<"Batch iteration : "<<IterN<<std::endl;
        std::cout<<std::setw(20)<<"Input Row : "<<InputRow<<std::endl;
        std::cout<<std::setw(20)<<"Input Col : "<<InputCol<<std::endl;
        std::cout<<std::setw(20)<<"Weight Row : "<<WeightRow<<std::endl;
        std::cout<<std::setw(20)<<"Weight Col : "<<WeightCol<<std::endl;
        std::cout<<std::setw(20)<<"Output Row : "<<OutputRow<<std::endl;
        std::cout<<std::setw(20)<<"Output Col : "<<OutputCol<<std::endl;
    }

};