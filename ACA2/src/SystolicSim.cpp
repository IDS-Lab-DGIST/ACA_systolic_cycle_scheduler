#include "SystolicSim.hpp"

//private function
long long SystolicSimOS::calculateLayer(Layer TargetLayer) {
        const unsigned PartialSumHeight = TargetLayer.WeightRow;
        const unsigned OutputRowQuotient = TargetLayer.OutputRow / mSystolicArrayConfig.Row;
        const unsigned OutputColQuotient = TargetLayer.OutputCol / mSystolicArrayConfig.Col;
        const unsigned OutputRowRemainder = TargetLayer.OutputRow % mSystolicArrayConfig.Row;
        const unsigned OutputColRemainder = TargetLayer.OutputCol % mSystolicArrayConfig.Col;

        const unsigned NormalCase = OutputRowQuotient * OutputColQuotient;
        const unsigned RightCase = (OutputColRemainder !=0) ? OutputRowQuotient : 0;
        const unsigned DownCase = (OutputRowRemainder !=0) ? OutputColQuotient : 0;
        const unsigned CornerCase = (OutputRowRemainder !=0 && OutputColRemainder !=0) ? 1 : 0;

        long long TotalCycles = TiledExecutionCycles(PartialSumHeight, mSystolicArrayConfig.Row, mSystolicArrayConfig.Col, TargetLayer.OutputRow ,NormalCase)
        + TiledExecutionCycles(PartialSumHeight, OutputRowRemainder, mSystolicArrayConfig.Col, TargetLayer.OutputRow, RightCase)
        + TiledExecutionCycles(PartialSumHeight, mSystolicArrayConfig.Row, OutputColRemainder, TargetLayer.OutputRow, DownCase)
        + TiledExecutionCycles(PartialSumHeight, OutputRowRemainder, OutputColRemainder, TargetLayer.OutputRow, CornerCase);

        TotalCycles = TotalCycles * TargetLayer.IterN;

        return TotalCycles;
    }

//will be replaced by lambda function
long long SystolicSimOS::TiledExecutionCycles(unsigned PartialSumHeight, unsigned TargetRow, unsigned TargetCol, unsigned FlushCycles ,unsigned Iteration){

    return (static_cast<long long>(PartialSumHeight) + static_cast<long long>(TargetRow) + static_cast<long long>(TargetCol) - 1.0 + static_cast<long long>(FlushCycles)) * static_cast<long long>(Iteration);
        
}


void SystolicSimOS::calculateDNN(void){

    //for(int i =  0;  i < (*mDNNs).size(); i++)

    for(int i =  0;  i < (*mDNNs).size(); i++)
    {
        mLayerCycles.push_back(DNNCycle((*(*mDNNs)[i]).getName() ));

        
    }


    for(int i =  0;  i < (*mDNNs).size(); i++)
    {
        //mLayerCycles[i].

        for(int j = 0; j < (*(*mDNNs)[i]).getDNNLayer().size(); j++)
        {
            mLayerCycles[i].setDNNCycle(  calculateLayer((*(*mDNNs)[i]).getDNNLayer()[j]) );
        }
    }

}

void SystolicSimOS::sumDNNcycles(void){

    for(int i =  0;  i < mLayerCycles.size(); i++)
    {
        mLayerCycles[i].sumTotalCycle();
    }

}


//public function
SystolicSimOS::SystolicSimOS(std::string Name, SystolicConfig SystolicConfig, const std::shared_ptr< std::vector<std::unique_ptr<DNN>>>& DNNs)
    :mName(Name),
    mSystolicArrayConfig{SystolicConfig},
    mDNNs(DNNs),   
    mLayerCycles(std::vector<DNNCycle>()) 
{    
    mLayerCycles.reserve((*mDNNs).size());

    calculateDNN();
    sumDNNcycles();
    
}

void SystolicSimOS::printSystolicConfig(void) const {
    std::cout<<"Systolic row : "<<mSystolicArrayConfig.Row;
    std::cout<<" Systolic col : "<<mSystolicArrayConfig.Col<<std::endl;
}


void SystolicSimOS::printLayerCycles(void) const {


    for(int i =  0;  i < mLayerCycles.size(); i++)
    {
        mLayerCycles[i].printCycle();
    }

}

void SystolicSimOS::printTotalCycle(void) const{


    
    for(int i =  0;  i < mLayerCycles.size(); i++)
    {
        mLayerCycles[i].printTotalCycle();
    }

    
}

/*
void SystolicSimOS::printResultFile(void) const
{
    std::string ResultPath = mName + "_result.txt"

	if( ResultPath.is_open() ){
		ResultPath << "Hello World!\n";
		ResultPath << "This is C++ File Contents.\n";
		ResultPath.close();
	}


}

*/