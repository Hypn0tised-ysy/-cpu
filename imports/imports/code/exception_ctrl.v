module exception_ctrl(EX_SCAUSE,INTMASK,STATUS,EXL_Set,INT_PEND,INT_Signal);
input [7:0] EX_SCAUSE;
input [7:0] INTMASK;
input [7:0] STATUS;
output EXL_Set;
output[2:0] INT_PEND;
output INT_Signal;

endmodule    