module PE_1(clk,rstn, a, b, out_a,out_b,control,out_c);

parameter C_WIDTH = 32;
parameter WIDTH = 8;

input clk,rstn;
input [WIDTH-1:0] a;
input [WIDTH-1:0] b;
input control;


output reg [WIDTH-1:0] out_a;
output reg [WIDTH-1:0] out_b;

output reg [C_WIDTH-1:0] out_c;


always@(posedge clk, negedge rstn)
begin
	if(!rstn)
	begin
		out_a <=0;
		out_b <=0;		
	end
	else
	begin
		out_a <=a;
		out_b <=b;
	end	
end

reg [C_WIDTH-1:0] reg_c;

always@(posedge clk, negedge rstn)
begin
	if(!rstn)
	begin
		reg_c <=0;
	end
	else
	begin
		reg_c <= reg_c + (a*b);

	end
end

always@(posedge clk, negedge rstn)
begin
	if(!rstn)
	begin
		out_c <= 0;
	end
	else
	begin
		if(control)
		begin
			out_c <= reg_c;
		end
		else
		begin
			out_c<=out_c;
		end
	end
end

endmodule
 

