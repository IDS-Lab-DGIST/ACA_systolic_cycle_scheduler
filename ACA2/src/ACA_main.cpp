
#include <iostream>
#include "SystolicSim.hpp"
#include "Layer.hpp"
#include "CommandLineParser.hpp"
#include "SystolicConfigParser.hpp"
#include "Parser.hpp"


int main(int argc, char** argv)
{

    const SystolicConfig config64x64 = { 64, 64 };
    const SystolicConfig config128x128 = { 128, 128 };
    const SystolicConfig config256x256 = { 256, 256 };
    
    CommandLineParser CommandLineInput(argc, argv);


    std::vector<std::string>  FileName = CommandLineInput.getFileName();
    std::string SystolicConfigFileName = CommandLineInput.getSystolicConfig();

    Parser ParserForDNNLayers(FileName);
    //ParserForDNNLayers.printDNNLayers();

    SystolicConfigParser ConfigParser(SystolicConfigFileName);
    //ConfigParser.printSystolicconfig();


    const std::shared_ptr< std::vector<std::unique_ptr<DNN>>>& DNNs = ParserForDNNLayers.getDNNLayers();

    SystolicSimOS simulation0(FileName[0],ConfigParser.getFristConfig(),DNNs);
    SystolicSimOS simulation1(FileName[0],ConfigParser.getSecondConfig(),DNNs);
    SystolicSimOS simulation2(FileName[0],ConfigParser.getThirdConfig(),DNNs);
    std::cout<<std::endl;

    simulation0.printSystolicConfig();
    simulation0.printLayerCycles();
    simulation0.printTotalCycle();
    std::cout<<std::endl;
  
    simulation1.printSystolicConfig();
    simulation1.printLayerCycles();
    simulation1.printTotalCycle();
    std::cout<<std::endl;

    simulation2.printSystolicConfig();
    simulation2.printLayerCycles();
    simulation2.printTotalCycle();
    std::cout<<std::endl;


}
