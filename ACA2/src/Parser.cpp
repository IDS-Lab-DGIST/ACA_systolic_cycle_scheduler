#include "Parser.hpp"

Parser::Parser(std::vector<std::string> FileName)
    :mFileNameVector(FileName)
    ,mDNNs(std::make_shared<std::vector <std::unique_ptr<DNN>> >())
{

    
    (*mDNNs).reserve(mFileNameVector.size());
    
    for ( int i = 0; i < mFileNameVector.size(); i++)
    {
        std::string delimiter = "/";
        const std::string FileName = mFileNameVector[i].substr(mFileNameVector[i].rfind(delimiter) + delimiter.length(), mFileNameVector[i].length());

        (*mDNNs).push_back(std::unique_ptr<DNN>(new DNN(FileName)));
    }
    
    for(auto iterator = mFileNameVector.begin(); iterator != mFileNameVector.end(); iterator++)
    {
        //get index
        int index = iterator - mFileNameVector.begin();

        //std::cout<<"reading text file"<<std::endl;
        readDNNTextFile((*iterator),index);

    }

    //printDNNs();
}


std::shared_ptr< std::vector<std::unique_ptr<DNN>>>  Parser::getDNNLayers(void){
    return mDNNs;
}


void Parser::printDNNLayers(void) const {
        
    for(int i =  0;  i < (*mDNNs).size(); i++)
    {
        //(*mDNNs)[i].print();
        (*(*mDNNs)[i]).printLayer();
    }
    
}

void Parser::readDNNTextFile(std::string FileName, int index)
{
    int cntLine = 0;
    std::fstream fin;
    std::string line;
    //fin.open("./resource/" + FileName);
    fin.open(FileName);

    
    std::string delimiter = ":";    
    std::string delimiter2 = "/";  
    ParserState CurrentState = ParserState::ReadStart;
    Layer Carrier = { "Empty", 0, 0, 0, 0, 0, 0 };  
    

    //std::cout<<"before getline"<<std::endl;
    while(getline(fin, line))
    {
        cntLine++;
        //aborting empty line
        //std::cout<<"Aborting empty line"<<std::endl;
        if(line.size() == 0)
            continue;
        
        //Deleting comments
        std::string commentStart = "/";
        std::string firstChar;
        firstChar.push_back(line.at(0));
        std::string secondChar;
        secondChar.push_back(line.at(1));
        if(firstChar == commentStart && secondChar == commentStart)
            continue;

        //Verifying correct form
        if(line.find(delimiter) == std::string::npos){
            /*
            std::cerr<<"Warning : ";
            std::cerr<<"Finding uncorret form string";
            std::cerr<<" in text file"<<index;
            std::cerr<<" line"<<cntLine<<std::endl;
            */
            continue;
        }
        

        //split
        //std::cout<<"Split"<<std::endl;
        std::string Dimension = line.substr(0, line.find(delimiter));
        std::string Content = line.substr(line.find(delimiter) + delimiter.length(), line.length());

        //Erase space or tab or someting empty
        //std::cout<<"Erase empty character"<<std::endl;
        Dimension.erase(remove_if(Dimension.begin(), Dimension.end(), isspace));
        Content.erase(remove_if(Content.begin(), Content.end(), isspace));

        if(Content.find(delimiter2) != std::string::npos){
            Content = Content.substr(0, Content.find(delimiter2));
        }

        //std::cout<<"Content : "<<Content<<std::endl;

        //std::cout<<"Content : "<<Content<<std::endl;

        //std::cout<<"Start switch syntax"<<std::endl;
        switch(CurrentState)
        {
        case ParserState::ReadStart:
            if(Dimension == "LayerName"){
                CurrentState = ParserState::CheckIterNOrInputRow;
                Carrier.LayerName = Content;
            }
            else
                CurrentState = ParserState::ReadStart;

            break;

        case ParserState::CheckIterNOrInputRow:
            if(Dimension == "IterN"){
                CurrentState = ParserState::CheckIterNOrInputRow;
                //std::cout<<"Content : "<<Content<<std::endl;

                Carrier.IterN = std::stoi(Content);
            }
            else if(Dimension == "InputRow"){
                CurrentState = ParserState::CheckInputCol;
                //std::cout<<"Content : "<<Content<<std::endl;

                Carrier.InputRow = std::stoi(Content);
            }
            else 
                CurrentState = ParserState::Fail;

            break;

        case ParserState::CheckInputCol:
            if(Dimension == "InputCol"){
                CurrentState = ParserState::CheckWeightRow;
                Carrier.InputCol = std::stoi(Content);
            }
            else
                CurrentState = ParserState::Fail;            
            break;

        case ParserState::CheckWeightRow:
            if(Dimension == "WeightRow"){
                CurrentState = ParserState::CheckWeightCol;
                Carrier.WeightRow = std::stoi(Content);
            }
            else
                CurrentState = ParserState::Fail;            
            break;

        case ParserState::CheckWeightCol:
            if(Dimension == "WeightCol"){
                CurrentState = ParserState::CheckOutputRow;
                Carrier.WeightCol = std::stoi(Content);

            }
            else
                CurrentState = ParserState::Fail;            
            break;
        case ParserState::CheckOutputRow:
            if(Dimension == "OutputRow"){
                CurrentState = ParserState::CheckOutputCol;
                Carrier.OutputRow = std::stoi(Content);
            }
            else
                CurrentState = ParserState::Fail;            
            break;


        case ParserState::CheckOutputCol:
            if(Dimension == "OutputCol"){
                CurrentState = ParserState::ReadStart;
                Carrier.OutputCol = std::stoi(Content);


                //mDNNs[index].push_back(Carrier);

                if(Carrier.IterN == 0){
                    Carrier.IterN = 1;
                }
                //Carrier.print();
                //mDNNs[index].second.push_back(Carrier);
                (*(*mDNNs)[index]).setDNNLayer(Carrier);
        
                
                //Empty carrier
                Carrier.Empty();
                
            }
            else
                CurrentState = ParserState::Fail;            
            break;

        case ParserState::Fail:
            std::cerr<<"Parsing fail"<<std::endl;
            std::cerr<<"text file"<<index<<" read fail"<<std::endl;
            std::cerr<<"line"<<cntLine - 1<<" read fail"<<std::endl;
            
            exit(1);

            break;
            
        default:
            std::cerr<<"Wrong state"<<std::endl;
            std::cerr<<"program termination"<<std::endl;
            exit(1);
            break;

        }
    }
    

    fin.close();       
}