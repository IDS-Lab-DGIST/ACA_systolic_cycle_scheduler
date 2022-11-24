#pragma once

enum class ParserState {
    ReadStart,
    CheckIterNOrInputRow,
    //CheckInputRow,
    CheckInputCol,
    CheckWeightRow,
    CheckWeightCol,
    CheckOutputRow,
    CheckOutputCol,
    Fail
};