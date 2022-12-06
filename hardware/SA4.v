module SA4(clk, rstn, activation, weight, control ,c_out,out_act,out_weight);
parameter WIDTH = 8;
parameter C_WIDTH = 32;

input clk,rstn;
input [4*WIDTH-1:0] activation;
input [4*WIDTH-1:0] weight;
input control;
output [16*C_WIDTH-1:0] c_out;
output [4*WIDTH-1:0] out_act;
output [4*WIDTH-1:0] out_weight;


wire [2*WIDTH-1:0] act_0;
wire [2*WIDTH-1:0] act_1;
wire [2*WIDTH-1:0] weight_0;
wire [2*WIDTH-1:0] weight_1;

wire [2*WIDTH-1:0] outact_0;
wire [2*WIDTH-1:0] outact_1;
wire [2*WIDTH-1:0] outweight_0;
wire [2*WIDTH-1:0] outweight_1;

wire [2*WIDTH-1:0] act0_1;
wire [2*WIDTH-1:0] act2_3;
wire [2*WIDTH-1:0] weight0_2;
wire [2*WIDTH-1:0] weight1_3;
wire [4*C_WIDTH-1:0] out_0;
wire [4*C_WIDTH-1:0] out_1;
wire [4*C_WIDTH-1:0] out_2;
wire [4*C_WIDTH-1:0] out_3;

assign {act_0,act_1} = activation;
assign {weight_0,weight_1} = weight;

SA2 SA2_0 (.clk(clk),.rstn(rstn),.activation(act_0),.weight(weight_0),.out_act(act0_1),.out_weight(weight0_2),.control(control),.c_out(out_0));
SA2 SA2_1 (.clk(clk),.rstn(rstn),.activation(act0_1),.weight(weight_1),.out_act(outact_0),.out_weight(weight1_3),.control(control),.c_out(out_1));
SA2 SA2_2 (.clk(clk),.rstn(rstn),.activation(act_1),.weight(weight0_2),.out_act(act2_3),.out_weight(outweight_0),.control(control),.c_out(out_2));
SA2 SA2_3 (.clk(clk),.rstn(rstn),.activation(act2_3),.weight(weight1_3),.out_act(outact_1),.out_weight(outweight_1),.control(control),.c_out(out_3));

assign out_act = {outact_0,outact_1};
assign out_weight = {outweight_0,outweight_1};

assign c_out = {out_0,out_1,out_2,out_3};


endmodule
