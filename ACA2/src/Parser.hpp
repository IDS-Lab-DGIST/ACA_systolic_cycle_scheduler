#pragma once

#define MAXIMUM_LAYER_NUMBER 100

#include <fstream>
#include <iostream>
#include <vector>
#include <algorithm>
#include <memory>

#include "Layer.hpp"
#include "DNNs.hpp"
#include "ParserState.hpp"

class Parser {
private:

    std::shared_ptr< std::vector<std::unique_ptr<DNN>>> mDNNs;
    const std::vector<std::string> mFileNameVector;

public:

    Parser(std::vector<std::string> FileName);
    std::shared_ptr< std::vector<std::unique_ptr<DNN>>>  getDNNLayers(void);
    void printDNNLayers(void) const;


private:

    void readDNNTextFile(std::string FileName, int index);
    
};