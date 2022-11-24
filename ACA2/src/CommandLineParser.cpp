#include "CommandLineParser.hpp"

CommandLineParser::CommandLineParser(int &argc, char **argv)
{
    
    mFileNameVector.reserve(argc-1);

    if (argc == 1){
        std::cerr<<"No file name is detected"<<std::endl;
        std::cerr<<"program tremination"<<std::endl;
    }

    if (argc > 3){
        std::cerr<<"Too many arugments"<<std::endl;
        std::cerr<<"Only 2 argument is available"<<std::endl;
        std::cerr<<"First one is systolic array configuration"<<std::endl;
        std::cerr<<"Second one is DNN file name"<<std::endl;
    }

    for (int i=1; i < argc; ++i)
        mTokens.push_back(std::string(argv[i]));


    std::fstream fin;
    bool FileNameCheck = true;

    for(auto token : mTokens)
    {
        fin.open(token);
        FileNameCheck = FileNameCheck && fin.is_open();
        fin.close();
        
    }

    if (FileNameCheck == false){
        std::cout<<"Wrong file name is detected"<<std::endl;
        exit(1);
    }


    for(auto token : mTokens)
    {
        mFileNameVector.push_back(token);
    }        


    mSystolicConfigTextName = mFileNameVector[0];
    mFileName.push_back( mFileNameVector[1] );

    //std::cout<<mFileName<<std::endl;
    //std::cout<<mFileNameVector[0]<<std::endl;
    //std::cout<<mFileNameVector[1]<<std::endl;

    //fin.close();
    
}



std::string CommandLineParser::getSystolicConfig(void) const {
    return mSystolicConfigTextName;
}

std::vector<std::string>  CommandLineParser::getFileName(void) const {
    return mFileName;
}
