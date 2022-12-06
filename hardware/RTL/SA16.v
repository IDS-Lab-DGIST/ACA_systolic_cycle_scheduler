module SA16(clk, rstn, activation, weight, control,c_out0,c_out1,c_out2,c_out3,c_out4,c_out5,c_out6,c_out7,out_act,out_weight);
parameter WIDTH = 8;
parameter C_WIDTH = 32;

input clk,rstn;
input [16*WIDTH-1:0] activation;
input [16*WIDTH-1:0] weight;
input control;
output [32*C_WIDTH-1:0] c_out0;
output [32*C_WIDTH-1:0] c_out1;
output [32*C_WIDTH-1:0] c_out2;
output [32*C_WIDTH-1:0] c_out3;
output [32*C_WIDTH-1:0] c_out4;
output [32*C_WIDTH-1:0] c_out5;
output [32*C_WIDTH-1:0] c_out6;
output [32*C_WIDTH-1:0] c_out7;
output [16*WIDTH-1:0] out_act;
output [16*WIDTH-1:0] out_weight;


wire [8*WIDTH-1:0] act_0;
wire [8*WIDTH-1:0] act_1;
wire [8*WIDTH-1:0] weight_0;
wire [8*WIDTH-1:0] weight_1;

wire [8*WIDTH-1:0] outact_0;
wire [8*WIDTH-1:0] outact_1;
wire [8*WIDTH-1:0] outweight_0;
wire [8*WIDTH-1:0] outweight_1;

wire [8*WIDTH-1:0] act0_1;
wire [8*WIDTH-1:0] act2_3;
wire [8*WIDTH-1:0] weight0_2;
wire [8*WIDTH-1:0] weight1_3;
wire [32*C_WIDTH-1:0] out_0;
wire [32*C_WIDTH-1:0] out_1;
wire [32*C_WIDTH-1:0] out_2;
wire [32*C_WIDTH-1:0] out_3;
wire [32*C_WIDTH-1:0] out_4;
wire [32*C_WIDTH-1:0] out_5;
wire [32*C_WIDTH-1:0] out_6;
wire [32*C_WIDTH-1:0] out_7;


assign {act_0,act_1} = activation;
assign {weight_0,weight_1} = weight;

SA8 SA8_0 (.clk(clk),.rstn(rstn),.activation(act_0),.weight(weight_0),.out_act(act0_1),.out_weight(weight0_2),.control(control),.c_out0(out_0),.c_out1(out_4));
SA8 SA8_1 (.clk(clk),.rstn(rstn),.activation(act0_1),.weight(weight_1),.out_act(outact_0),.out_weight(weight1_3),.control(control),.c_out0(out_1),.c_out1(out_5));
SA8 SA8_2 (.clk(clk),.rstn(rstn),.activation(act_1),.weight(weight0_2),.out_act(act2_3),.out_weight(outweight_0),.control(control),.c_out0(out_2),.c_out1(out_6));
SA8 SA8_3 (.clk(clk),.rstn(rstn),.activation(act2_3),.weight(weight1_3),.out_act(outact_1),.out_weight(outweight_1),.control(control),.c_out0(out_3),.c_out1(out_7));

assign out_act = {outact_0,outact_1};
assign out_weight = {outweight_0,outweight_1};

assign c_out0 = out_0;
assign c_out1 = out_1;
assign c_out2 = out_2;
assign c_out3 = out_3;
assign c_out4 = out_4;
assign c_out5 = out_5;
assign c_out6 = out_6;
assign c_out7 = out_7;


endmodule
