#pragma once

#include <string>
#include <iostream>
#include <vector>
#include <fstream>


class CommandLineParser {

private:
    std::vector<std::string> mTokens;
    std::vector<std::string> mFileNameVector;

    std::vector<std::string> mFileName;
    std::string mSystolicConfigTextName;

public:
    CommandLineParser(int &argc, char **argv);
    std::string getSystolicConfig(void) const;
    std::vector<std::string> getFileName(void) const;

};