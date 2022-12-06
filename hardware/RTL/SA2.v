module SA2(clk, rstn, activation, weight, control ,c_out,out_act,out_weight);
parameter WIDTH = 8;
parameter C_WIDTH = 32;

input clk,rstn;
input [2*WIDTH-1:0] activation;
input [2*WIDTH-1:0] weight;
input control;
output [4*C_WIDTH-1:0] c_out;
output [2*WIDTH-1:0] out_act;
output [2*WIDTH-1:0] out_weight;


wire [WIDTH-1:0] act_0;
wire [WIDTH-1:0] act_1;
wire [WIDTH-1:0] weight_0;
wire [WIDTH-1:0] weight_1;

wire [WIDTH-1:0] outact_0;
wire [WIDTH-1:0] outact_1;
wire [WIDTH-1:0] outweight_0;
wire [WIDTH-1:0] outweight_1;

wire [WIDTH-1:0] act0_1;
wire [WIDTH-1:0] act2_3;
wire [WIDTH-1:0] weight0_2;
wire [WIDTH-1:0] weight1_3;
wire [C_WIDTH-1:0] out_0;
wire [C_WIDTH-1:0] out_1;
wire [C_WIDTH-1:0] out_2;
wire [C_WIDTH-1:0] out_3;

assign {act_0,act_1} = activation;
assign {weight_0,weight_1} = weight;

PE_1 PE0 (.clk(clk),.rstn(rstn),.a(act_0),.b(weight_0),.out_a(act0_1),.out_b(weight0_2),.control(control),.out_c(out_0));
PE_1 PE1 (.clk(clk),.rstn(rstn),.a(act0_1),.b(weight_1),.out_a(outact_0),.out_b(weight1_3),.control(control),.out_c(out_1));
PE_1 PE2 (.clk(clk),.rstn(rstn),.a(act_1),.b(weight0_2),.out_a(act2_3),.out_b(outweight_0),.control(control),.out_c(out_2));
PE_1 PE3 (.clk(clk),.rstn(rstn),.a(act2_3),.b(weight1_3),.out_a(outact_1),.out_b(outweight_1),.control(control),.out_c(out_3));

assign out_act = {outact_0,outact_1};
assign out_weight = {outweight_0,outweight_1};

assign c_out = {out_0,out_1,out_2,out_3};


endmodule
