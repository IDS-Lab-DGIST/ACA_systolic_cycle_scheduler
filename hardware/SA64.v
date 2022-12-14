module SA64(clk, rstn, activation, weight, control ,c_out0,c_out1,c_out2,c_out3,c_out4,c_out5,c_out6,c_out7,c_out8,c_out9,c_out10,c_out11,c_out12,c_out13,c_out14,c_out15,c_out16,c_out17,c_out18,c_out19,c_out20,c_out21,c_out22,c_out23,c_out24,c_out25,c_out26,c_out27,c_out28,c_out29,c_out30,c_out31,c_out32,c_out33,c_out34,c_out35,c_out36,c_out37,c_out38,c_out39,c_out40,c_out41,c_out42,c_out43,c_out44,c_out45,c_out46,c_out47,c_out48,c_out49,c_out50,c_out51,c_out52,c_out53,c_out54,c_out55,c_out56,c_out57,c_out58,c_out59,c_out60,c_out61,c_out62,c_out63,c_out64,c_out65,c_out66,c_out67,c_out68,c_out69,c_out70,c_out71,c_out72,c_out73,c_out74,c_out75,c_out76,c_out77,c_out78,c_out79,c_out80,c_out81,c_out82,c_out83,c_out84,c_out85,c_out86,c_out87,c_out88,c_out89,c_out90,c_out91,c_out92,c_out93,c_out94,c_out95,c_out96,c_out97,c_out98,c_out99,c_out100,c_out101,c_out102,c_out103,c_out104,c_out105,c_out106,c_out107,c_out108,c_out109,c_out110,c_out111,c_out112,c_out113,c_out114,c_out115,c_out116,c_out117,c_out118,c_out119,c_out120,c_out121,c_out122,c_out123,c_out124,c_out125,c_out126,c_out127,out_act,out_weight);
parameter WIDTH = 8;
parameter C_WIDTH = 32;

input clk,rstn;
input [64*WIDTH-1:0] activation;
input [64*WIDTH-1:0] weight;
input control;
output [32*C_WIDTH-1:0] c_out0;
output [32*C_WIDTH-1:0] c_out1;
output [32*C_WIDTH-1:0] c_out2;
output [32*C_WIDTH-1:0] c_out3;
output [32*C_WIDTH-1:0] c_out4;
output [32*C_WIDTH-1:0] c_out5;
output [32*C_WIDTH-1:0] c_out6;
output [32*C_WIDTH-1:0] c_out7;
output [32*C_WIDTH-1:0] c_out8;
output [32*C_WIDTH-1:0] c_out9;
output [32*C_WIDTH-1:0] c_out10;
output [32*C_WIDTH-1:0] c_out11;
output [32*C_WIDTH-1:0] c_out12;
output [32*C_WIDTH-1:0] c_out13;
output [32*C_WIDTH-1:0] c_out14;
output [32*C_WIDTH-1:0] c_out15;
output [32*C_WIDTH-1:0] c_out16;
output [32*C_WIDTH-1:0] c_out17;
output [32*C_WIDTH-1:0] c_out18;
output [32*C_WIDTH-1:0] c_out19;
output [32*C_WIDTH-1:0] c_out20;
output [32*C_WIDTH-1:0] c_out21;
output [32*C_WIDTH-1:0] c_out22;
output [32*C_WIDTH-1:0] c_out23;
output [32*C_WIDTH-1:0] c_out24;
output [32*C_WIDTH-1:0] c_out25;
output [32*C_WIDTH-1:0] c_out26;
output [32*C_WIDTH-1:0] c_out27;
output [32*C_WIDTH-1:0] c_out28;
output [32*C_WIDTH-1:0] c_out29;
output [32*C_WIDTH-1:0] c_out30;
output [32*C_WIDTH-1:0] c_out31;
output [32*C_WIDTH-1:0] c_out32;
output [32*C_WIDTH-1:0] c_out33;
output [32*C_WIDTH-1:0] c_out34;
output [32*C_WIDTH-1:0] c_out35;
output [32*C_WIDTH-1:0] c_out36;
output [32*C_WIDTH-1:0] c_out37;
output [32*C_WIDTH-1:0] c_out38;
output [32*C_WIDTH-1:0] c_out39;
output [32*C_WIDTH-1:0] c_out40;
output [32*C_WIDTH-1:0] c_out41;
output [32*C_WIDTH-1:0] c_out42;
output [32*C_WIDTH-1:0] c_out43;
output [32*C_WIDTH-1:0] c_out44;
output [32*C_WIDTH-1:0] c_out45;
output [32*C_WIDTH-1:0] c_out46;
output [32*C_WIDTH-1:0] c_out47;
output [32*C_WIDTH-1:0] c_out48;
output [32*C_WIDTH-1:0] c_out49;
output [32*C_WIDTH-1:0] c_out50;
output [32*C_WIDTH-1:0] c_out51;
output [32*C_WIDTH-1:0] c_out52;
output [32*C_WIDTH-1:0] c_out53;
output [32*C_WIDTH-1:0] c_out54;
output [32*C_WIDTH-1:0] c_out55;
output [32*C_WIDTH-1:0] c_out56;
output [32*C_WIDTH-1:0] c_out57;
output [32*C_WIDTH-1:0] c_out58;
output [32*C_WIDTH-1:0] c_out59;
output [32*C_WIDTH-1:0] c_out60;
output [32*C_WIDTH-1:0] c_out61;
output [32*C_WIDTH-1:0] c_out62;
output [32*C_WIDTH-1:0] c_out63;
output [32*C_WIDTH-1:0] c_out64;
output [32*C_WIDTH-1:0] c_out65;
output [32*C_WIDTH-1:0] c_out66;
output [32*C_WIDTH-1:0] c_out67;
output [32*C_WIDTH-1:0] c_out68;
output [32*C_WIDTH-1:0] c_out69;
output [32*C_WIDTH-1:0] c_out70;
output [32*C_WIDTH-1:0] c_out71;
output [32*C_WIDTH-1:0] c_out72;
output [32*C_WIDTH-1:0] c_out73;
output [32*C_WIDTH-1:0] c_out74;
output [32*C_WIDTH-1:0] c_out75;
output [32*C_WIDTH-1:0] c_out76;
output [32*C_WIDTH-1:0] c_out77;
output [32*C_WIDTH-1:0] c_out78;
output [32*C_WIDTH-1:0] c_out79;
output [32*C_WIDTH-1:0] c_out80;
output [32*C_WIDTH-1:0] c_out81;
output [32*C_WIDTH-1:0] c_out82;
output [32*C_WIDTH-1:0] c_out83;
output [32*C_WIDTH-1:0] c_out84;
output [32*C_WIDTH-1:0] c_out85;
output [32*C_WIDTH-1:0] c_out86;
output [32*C_WIDTH-1:0] c_out87;
output [32*C_WIDTH-1:0] c_out88;
output [32*C_WIDTH-1:0] c_out89;
output [32*C_WIDTH-1:0] c_out90;
output [32*C_WIDTH-1:0] c_out91;
output [32*C_WIDTH-1:0] c_out92;
output [32*C_WIDTH-1:0] c_out93;
output [32*C_WIDTH-1:0] c_out94;
output [32*C_WIDTH-1:0] c_out95;
output [32*C_WIDTH-1:0] c_out96;
output [32*C_WIDTH-1:0] c_out97;
output [32*C_WIDTH-1:0] c_out98;
output [32*C_WIDTH-1:0] c_out99;
output [32*C_WIDTH-1:0] c_out100;
output [32*C_WIDTH-1:0] c_out101;
output [32*C_WIDTH-1:0] c_out102;
output [32*C_WIDTH-1:0] c_out103;
output [32*C_WIDTH-1:0] c_out104;
output [32*C_WIDTH-1:0] c_out105;
output [32*C_WIDTH-1:0] c_out106;
output [32*C_WIDTH-1:0] c_out107;
output [32*C_WIDTH-1:0] c_out108;
output [32*C_WIDTH-1:0] c_out109;
output [32*C_WIDTH-1:0] c_out110;
output [32*C_WIDTH-1:0] c_out111;
output [32*C_WIDTH-1:0] c_out112;
output [32*C_WIDTH-1:0] c_out113;
output [32*C_WIDTH-1:0] c_out114;
output [32*C_WIDTH-1:0] c_out115;
output [32*C_WIDTH-1:0] c_out116;
output [32*C_WIDTH-1:0] c_out117;
output [32*C_WIDTH-1:0] c_out118;
output [32*C_WIDTH-1:0] c_out119;
output [32*C_WIDTH-1:0] c_out120;
output [32*C_WIDTH-1:0] c_out121;
output [32*C_WIDTH-1:0] c_out122;
output [32*C_WIDTH-1:0] c_out123;
output [32*C_WIDTH-1:0] c_out124;
output [32*C_WIDTH-1:0] c_out125;
output [32*C_WIDTH-1:0] c_out126;
output [32*C_WIDTH-1:0] c_out127;
output [64*WIDTH-1:0] out_act;
output [64*WIDTH-1:0] out_weight;


wire [32*WIDTH-1:0] act_0;
wire [32*WIDTH-1:0] act_1;
wire [32*WIDTH-1:0] weight_0;
wire [32*WIDTH-1:0] weight_1;

wire [32*WIDTH-1:0] outact_0;
wire [32*WIDTH-1:0] outact_1;
wire [32*WIDTH-1:0] outweight_0;
wire [32*WIDTH-1:0] outweight_1;

wire [32*WIDTH-1:0] act0_1;
wire [32*WIDTH-1:0] act2_3;
wire [32*WIDTH-1:0] weight0_2;
wire [32*WIDTH-1:0] weight1_3;
wire [32*C_WIDTH-1:0] out_0;
wire [32*C_WIDTH-1:0] out_1;
wire [32*C_WIDTH-1:0] out_2;
wire [32*C_WIDTH-1:0] out_3;
wire [32*C_WIDTH-1:0] out_4;
wire [32*C_WIDTH-1:0] out_5;
wire [32*C_WIDTH-1:0] out_6;
wire [32*C_WIDTH-1:0] out_7;
wire [32*C_WIDTH-1:0] out_8;
wire [32*C_WIDTH-1:0] out_9;
wire [32*C_WIDTH-1:0] out_10;
wire [32*C_WIDTH-1:0] out_11;
wire [32*C_WIDTH-1:0] out_12;
wire [32*C_WIDTH-1:0] out_13;
wire [32*C_WIDTH-1:0] out_14;
wire [32*C_WIDTH-1:0] out_15;
wire [32*C_WIDTH-1:0] out_16;
wire [32*C_WIDTH-1:0] out_17;
wire [32*C_WIDTH-1:0] out_18;
wire [32*C_WIDTH-1:0] out_19;
wire [32*C_WIDTH-1:0] out_20;
wire [32*C_WIDTH-1:0] out_21;
wire [32*C_WIDTH-1:0] out_22;
wire [32*C_WIDTH-1:0] out_23;
wire [32*C_WIDTH-1:0] out_24;
wire [32*C_WIDTH-1:0] out_25;
wire [32*C_WIDTH-1:0] out_26;
wire [32*C_WIDTH-1:0] out_27;
wire [32*C_WIDTH-1:0] out_28;
wire [32*C_WIDTH-1:0] out_29;
wire [32*C_WIDTH-1:0] out_30;
wire [32*C_WIDTH-1:0] out_31;
wire [32*C_WIDTH-1:0] out_32;
wire [32*C_WIDTH-1:0] out_33;
wire [32*C_WIDTH-1:0] out_34;
wire [32*C_WIDTH-1:0] out_35;
wire [32*C_WIDTH-1:0] out_36;
wire [32*C_WIDTH-1:0] out_37;
wire [32*C_WIDTH-1:0] out_38;
wire [32*C_WIDTH-1:0] out_39;
wire [32*C_WIDTH-1:0] out_40;
wire [32*C_WIDTH-1:0] out_41;
wire [32*C_WIDTH-1:0] out_42;
wire [32*C_WIDTH-1:0] out_43;
wire [32*C_WIDTH-1:0] out_44;
wire [32*C_WIDTH-1:0] out_45;
wire [32*C_WIDTH-1:0] out_46;
wire [32*C_WIDTH-1:0] out_47;
wire [32*C_WIDTH-1:0] out_48;
wire [32*C_WIDTH-1:0] out_49;
wire [32*C_WIDTH-1:0] out_50;
wire [32*C_WIDTH-1:0] out_51;
wire [32*C_WIDTH-1:0] out_52;
wire [32*C_WIDTH-1:0] out_53;
wire [32*C_WIDTH-1:0] out_54;
wire [32*C_WIDTH-1:0] out_55;
wire [32*C_WIDTH-1:0] out_56;
wire [32*C_WIDTH-1:0] out_57;
wire [32*C_WIDTH-1:0] out_58;
wire [32*C_WIDTH-1:0] out_59;
wire [32*C_WIDTH-1:0] out_60;
wire [32*C_WIDTH-1:0] out_61;
wire [32*C_WIDTH-1:0] out_62;
wire [32*C_WIDTH-1:0] out_63;
wire [32*C_WIDTH-1:0] out_64;
wire [32*C_WIDTH-1:0] out_65;
wire [32*C_WIDTH-1:0] out_66;
wire [32*C_WIDTH-1:0] out_67;
wire [32*C_WIDTH-1:0] out_68;
wire [32*C_WIDTH-1:0] out_69;
wire [32*C_WIDTH-1:0] out_70;
wire [32*C_WIDTH-1:0] out_71;
wire [32*C_WIDTH-1:0] out_72;
wire [32*C_WIDTH-1:0] out_73;
wire [32*C_WIDTH-1:0] out_74;
wire [32*C_WIDTH-1:0] out_75;
wire [32*C_WIDTH-1:0] out_76;
wire [32*C_WIDTH-1:0] out_77;
wire [32*C_WIDTH-1:0] out_78;
wire [32*C_WIDTH-1:0] out_79;
wire [32*C_WIDTH-1:0] out_80;
wire [32*C_WIDTH-1:0] out_81;
wire [32*C_WIDTH-1:0] out_82;
wire [32*C_WIDTH-1:0] out_83;
wire [32*C_WIDTH-1:0] out_84;
wire [32*C_WIDTH-1:0] out_85;
wire [32*C_WIDTH-1:0] out_86;
wire [32*C_WIDTH-1:0] out_87;
wire [32*C_WIDTH-1:0] out_88;
wire [32*C_WIDTH-1:0] out_89;
wire [32*C_WIDTH-1:0] out_90;
wire [32*C_WIDTH-1:0] out_91;
wire [32*C_WIDTH-1:0] out_92;
wire [32*C_WIDTH-1:0] out_93;
wire [32*C_WIDTH-1:0] out_94;
wire [32*C_WIDTH-1:0] out_95;
wire [32*C_WIDTH-1:0] out_96;
wire [32*C_WIDTH-1:0] out_97;
wire [32*C_WIDTH-1:0] out_98;
wire [32*C_WIDTH-1:0] out_99;
wire [32*C_WIDTH-1:0] out_100;
wire [32*C_WIDTH-1:0] out_101;
wire [32*C_WIDTH-1:0] out_102;
wire [32*C_WIDTH-1:0] out_103;
wire [32*C_WIDTH-1:0] out_104;
wire [32*C_WIDTH-1:0] out_105;
wire [32*C_WIDTH-1:0] out_106;
wire [32*C_WIDTH-1:0] out_107;
wire [32*C_WIDTH-1:0] out_108;
wire [32*C_WIDTH-1:0] out_109;
wire [32*C_WIDTH-1:0] out_110;
wire [32*C_WIDTH-1:0] out_111;
wire [32*C_WIDTH-1:0] out_112;
wire [32*C_WIDTH-1:0] out_113;
wire [32*C_WIDTH-1:0] out_114;
wire [32*C_WIDTH-1:0] out_115;
wire [32*C_WIDTH-1:0] out_116;
wire [32*C_WIDTH-1:0] out_117;
wire [32*C_WIDTH-1:0] out_118;
wire [32*C_WIDTH-1:0] out_119;
wire [32*C_WIDTH-1:0] out_120;
wire [32*C_WIDTH-1:0] out_121;
wire [32*C_WIDTH-1:0] out_122;
wire [32*C_WIDTH-1:0] out_123;
wire [32*C_WIDTH-1:0] out_124;
wire [32*C_WIDTH-1:0] out_125;
wire [32*C_WIDTH-1:0] out_126;
wire [32*C_WIDTH-1:0] out_127;

assign {act_0,act_1} = activation;
assign {weight_0,weight_1} = weight;

SA32 SA32_0 (.clk(clk),.rstn(rstn),.activation(act_0),.weight(weight_0),.control(control),.c_out0(out_0),.c_out1(out_1),.c_out2(out_2),.c_out3(out_3),.c_out4(out_4),.c_out5(out_5),.c_out6(out_6),.c_out7(out_7),.c_out8(out_8),.c_out9(out_9),.c_out10(out_10),.c_out11(out_11),.c_out12(out_12),.c_out13(out_13),.c_out14(out_14),.c_out15(out_15),.c_out16(out_16),.c_out17(out_17),.c_out18(out_18),.c_out19(out_19),.c_out20(out_20),.c_out21(out_21),.c_out22(out_22),.c_out23(out_23),.c_out24(out_24),.c_out25(out_25),.c_out26(out_26),.c_out27(out_27),.c_out28(out_28),.c_out29(out_29),.c_out30(out_30),.c_out31(out_31),.out_act(act0_1),.out_weight(weight0_2));
SA32 SA32_1 (.clk(clk),.rstn(rstn),.activation(act0_1),.weight(weight_1),.out_act(outact_0),.out_weight(weight1_3),.control(control),.c_out0(out_32),.c_out1(out_33),.c_out2(out_34),.c_out3(out_35),.c_out4(out_36),.c_out5(out_37),.c_out6(out_38),.c_out7(out_39),.c_out8(out_40),.c_out9(out_41),.c_out10(out_42),.c_out11(out_43),.c_out12(out_44),.c_out13(out_45),.c_out14(out_46),.c_out15(out_47),.c_out16(out_48),.c_out17(out_49),.c_out18(out_50),.c_out19(out_51),.c_out20(out_52),.c_out21(out_53),.c_out22(out_54),.c_out23(out_55),.c_out24(out_56),.c_out25(out_57),.c_out26(out_58),.c_out27(out_59),.c_out28(out_60),.c_out29(out_61),.c_out30(out_62),.c_out31(out_63));
SA32 SA32_2 (.clk(clk),.rstn(rstn),.activation(act_1),.weight(weight0_2),.out_act(act2_3),.out_weight(outweight_0),.control(control),.c_out0(out_64),.c_out1(out_65),.c_out2(out_66),.c_out3(out_67),.c_out4(out_68),.c_out5(out_69),.c_out6(out_70),.c_out7(out_71),.c_out8(out_72),.c_out9(out_73),.c_out10(out_74),.c_out11(out_75),.c_out12(out_76),.c_out13(out_77),.c_out14(out_78),.c_out15(out_79),.c_out16(out_80),.c_out17(out_81),.c_out18(out_82),.c_out19(out_83),.c_out20(out_84),.c_out21(out_85),.c_out22(out_86),.c_out23(out_87),.c_out24(out_88),.c_out25(out_89),.c_out26(out_90),.c_out27(out_91),.c_out28(out_92),.c_out29(out_93),.c_out30(out_94),.c_out31(out_95));
SA32 SA32_3 (.clk(clk),.rstn(rstn),.activation(act2_3),.weight(weight1_3),.out_act(outact_1),.out_weight(outweight_1),.control(control),.c_out0(out_96),.c_out1(out_97),.c_out2(out_98),.c_out3(out_99),.c_out4(out_100),.c_out5(out_101),.c_out6(out_102),.c_out7(out_103),.c_out8(out_104),.c_out9(out_105),.c_out10(out_106),.c_out11(out_107),.c_out12(out_108),.c_out13(out_109),.c_out14(out_110),.c_out15(out_111),.c_out16(out_112),.c_out17(out_113),.c_out18(out_114),.c_out19(out_115),.c_out20(out_116),.c_out21(out_117),.c_out22(out_118),.c_out23(out_119),.c_out24(out_120),.c_out25(out_121),.c_out26(out_122),.c_out27(out_123),.c_out28(out_124),.c_out29(out_125),.c_out30(out_126),.c_out31(out_127));

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
assign c_out8 = out_8;
assign c_out9 = out_9;
assign c_out10 = out_10;
assign c_out11 = out_11;
assign c_out12 = out_12;
assign c_out13 = out_13;
assign c_out14 = out_14;
assign c_out15 = out_15;
assign c_out16 = out_16;
assign c_out17 = out_17;
assign c_out18 = out_18;
assign c_out19 = out_19;
assign c_out20 = out_20;
assign c_out21 = out_21;
assign c_out22 = out_22;
assign c_out23 = out_23;
assign c_out24 = out_24;
assign c_out25 = out_25;
assign c_out26 = out_26;
assign c_out27 = out_27;
assign c_out28 = out_28;
assign c_out29 = out_29;
assign c_out30 = out_30;
assign c_out31 = out_31;
assign c_out32 = out_32;
assign c_out33 = out_33;
assign c_out34 = out_34;
assign c_out35 = out_35;
assign c_out36 = out_36;
assign c_out37 = out_37;
assign c_out38 = out_38;
assign c_out39 = out_39;
assign c_out40 = out_40;
assign c_out41 = out_41;
assign c_out42 = out_42;
assign c_out43 = out_43;
assign c_out44 = out_44;
assign c_out45 = out_45;
assign c_out46 = out_46;
assign c_out47 = out_47;
assign c_out48 = out_48;
assign c_out49 = out_49;
assign c_out50 = out_50;
assign c_out51 = out_51;
assign c_out52 = out_52;
assign c_out53 = out_53;
assign c_out54 = out_54;
assign c_out55 = out_55;
assign c_out56 = out_56;
assign c_out57 = out_57;
assign c_out58 = out_58;
assign c_out59 = out_59;
assign c_out60 = out_60;
assign c_out61 = out_61;
assign c_out62 = out_62;
assign c_out63 = out_63;
assign c_out64 = out_64;
assign c_out65 = out_65;
assign c_out66 = out_66;
assign c_out67 = out_67;
assign c_out68 = out_68;
assign c_out69 = out_69;
assign c_out70 = out_70;
assign c_out71 = out_71;
assign c_out72 = out_72;
assign c_out73 = out_73;
assign c_out74 = out_74;
assign c_out75 = out_75;
assign c_out76 = out_76;
assign c_out77 = out_77;
assign c_out78 = out_78;
assign c_out79 = out_79;
assign c_out80 = out_80;
assign c_out81 = out_81;
assign c_out82 = out_82;
assign c_out83 = out_83;
assign c_out84 = out_84;
assign c_out85 = out_85;
assign c_out86 = out_86;
assign c_out87 = out_87;
assign c_out88 = out_88;
assign c_out89 = out_89;
assign c_out90 = out_90;
assign c_out91 = out_91;
assign c_out92 = out_92;
assign c_out93 = out_93;
assign c_out94 = out_94;
assign c_out95 = out_95;
assign c_out96 = out_96;
assign c_out97 = out_97;
assign c_out98 = out_98;
assign c_out99 = out_99;
assign c_out100 = out_100;
assign c_out101 = out_101;
assign c_out102 = out_102;
assign c_out103 = out_103;
assign c_out104 = out_104;
assign c_out105 = out_105;
assign c_out106 = out_106;
assign c_out107 = out_107;
assign c_out108 = out_108;
assign c_out109 = out_109;
assign c_out110 = out_110;
assign c_out111 = out_111;
assign c_out112 = out_112;
assign c_out113 = out_113;
assign c_out114 = out_114;
assign c_out115 = out_115;
assign c_out116 = out_116;
assign c_out117 = out_117;
assign c_out118 = out_118;
assign c_out119 = out_119;
assign c_out120 = out_120;
assign c_out121 = out_121;
assign c_out122 = out_122;
assign c_out123 = out_123;
assign c_out124 = out_124;
assign c_out125 = out_125;
assign c_out126 = out_126;
assign c_out127 = out_127;


endmodule
