module PC(PCWrite, clk, rst, NPC, PC ,int_signal,ERET,ERETN,SEPC);
  input PCWrite;
  input              clk;
  input              rst;
  input       [31:0] NPC;

  input [31:0]SEPC;
  input ERET;
  input ERETN;
  input int_signal;

  output reg  [31:0] PC;

  always @(posedge clk, posedge rst)
    if (rst) 
      PC <= 32'h0000_0000;
//      PC <= 32'h0000_3000;
    else if (int_signal)
        PC<=32'h000000cc;
    else if (ERETN)
        PC<=SEPC+4;
    else if (ERET)
        PC<=SEPC;
    else if(PCWrite)
        PC <= NPC;
      
endmodule

