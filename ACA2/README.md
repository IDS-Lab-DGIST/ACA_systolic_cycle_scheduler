Programmed by Jooyeon Lee, Dahoon Park, Jahyeon Koo, and Sueungpyo Lee

1. Place target DNN file in resouce folder
file extension must be text format and follow below format of each layer
LayerName : "conv1"
InputRow : Input row number
InputCol : Input col number
WeightRow : Weight row number
WeightCol : Weight col number
OutputRow : Output row number
OutputCol : Output col number

2. Type "make" to compile programm

3. Run the program with target DNN files location as a commandline arguments

4. Also, the program can be runned by run shell

5. make clean will delete all the generated file which includes object file and run.shell file