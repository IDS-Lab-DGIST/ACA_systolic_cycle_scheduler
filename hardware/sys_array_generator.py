def verilog(a,b,c):#32 : a, 64 : b, 128 : c
    with open("./TOP.v",'w') as f:
        f.write("module TOP(\n")
        f.write("clk,rstn,")
        f.write("control,\n")
        for i in range(a):
            f.write(f"activation_32_{i},\n")
        for i in range(b):
            f.write(f"activation_64_{i},\n")
        for i in range(c):
            f.write(f"activation_128_{i},\n")
        for i in range(a):
            f.write(f"weight_32_{i},\n")
        for i in range(b):
            f.write(f"weight_64_{i},\n")
        for i in range(c):
            f.write(f"weight_128_{i},\n")
        for i in range(a):
            for j in range(32):
                f.write(f"out_32_{j}_{i},\n")
        for i in range(b):
            for j in range(128):
                f.write(f"out_64_{j}_{i},\n")
        for i in range(c):
            for j in range(512):
                f.write(f"out_128_{j}_{i},\n")
        for i in range(a):
            f.write(f"out_act_32_{i},\n")
            f.write(f"out_weight_32_{i},\n")
        for i in range(b):
            f.write(f"out_act_64_{i},\n")
            f.write(f"out_weight_64_{i},\n")
        for i in range(c):
            if i is not c-1:
                f.write(f"out_act_128_{i},\n")
                f.write(f"out_weight_128_{i},\n")
            else:
                f.write(f"out_act_128_{i},\n")
                f.write(f"out_weight_128_{i}\n")
        f.write(");\n")
        f.write("parameter WDITH = 8;\n")
        f.write("parameter C_WDITH = 32;\n")
        f.write("input clk,rstn,control;\n")
        for i in range(a):
            f.write(f"input [32*WIDTH-1:0] in_32_{i};\n")
        for i in range(b):
            f.write(f"input [64*WIDTH-1:0] in_64_{i};\n")
        for i in range(c):
            f.write(f"input [128*WIDTH-1:0] in_128_{i};\n")
        for i in range(a):
            f.write(f"input [32*WIDTH-1:0] weight_32_{i};\n")
        for i in range(b):
            f.write(f"input [64*WIDTH-1:0] weight_64_{i};\n")
        for i in range(c):
            f.write(f"input [128*WIDTH-1:0] weight_128_{i};\n")
        for i in range(a):
            for j in range(64):
                f.write(f"output [32*WIDTH-1:0] out_32_{j}_{i};\n")
        for i in range(b):
            for j in range(512):
                f.write(f"output [32*WIDTH-1:0] out_64_{j}_{i};\n")
        for i in range(c):
            for j in range(2048):
                f.write(f"output [32*WIDTH-1:0] out_128_{j}_{i};\n")
        for i in range(a):
            f.write(f"SA32 SA32_{i} (.clk(clk),.rstn(rstn),.control(control),.activation(activation_32_{i}),.weight(weight_32_{i}),.out_act(out_act_32_{i}),.out_weight(out_weight_32_{i}),\n")
            for j in range(32):
                if j != 31:
                    f.write(f".c_out{j}(out_32_{j}_{i}),\n")
                else:
                    f.write(f".c_out{j}(out_32_{j}_{i})\n")
            f.write(");\n")
        for i in range(b):
            f.write(f"SA64 SA64_{i} (.clk(clk),.rstn(rstn),.control(control),.activation(activation_64_{i}),.weight(weight_64_{i}),.out_act(out_act_64_{i}),.out_weight(out_weight_64_{i}),\n")
            for j in range(128):
                if j != 127:
                    f.write(f".c_out{j}(out_64_{j}_{i}),\n")
                else:
                    f.write(f".c_out{j}(out_64_{j}_{i})")
            f.write(");\n")
        for i in range(c):
            f.write(f"SA128 SA128_{i} (.clk(clk),.rstn(rstn),.control(control),.activation(activation_128_{i}),.weight(weight_128_{i}),.out_act(out_act_128_{i}),.out_weight(out_weight_128_{i}),\n")
            for j in range(512):
                if j != 511:
                    f.write(f".c_out{j}(out_128_{j}_{i}),\n")
                else:
                    f.write(f".c_out{j}(out_128_{j}_{i})")
            f.write(");\n")
        f.write("endmodule")
        
    if __name__== '__main__':
        a,b,c = 1,1,1
        verilog(a,b,c)
        return