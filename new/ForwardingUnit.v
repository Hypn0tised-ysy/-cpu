`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/01 10:34:00
// Design Name: 
// Module Name: forward_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ForwardingUnit(
    input MEM_RegWrite,// EX/MEM RegWrite 
    input [4:0] MEM_rd, // EX/MEM RegisterRd
    input WB_RegWrite, //MEM/WB RegWrite
    input [4:0]WB_rd, //MEM/WB RigisterRd
    input [4:0]EX_rs, //EX/MEM RegisterRs1/2
    output [1:0] ForwardSignal //00 from regfile 10 from MEM_aluout 01 from WB_rd
    );

    wire MEM_Forward;
    assign MEM_Forward=~(|(MEM_rd^EX_rs))&MEM_RegWrite;
    wire WB_Forward;
    assign WB_Forward=~(|(WB_rd^EX_rs))&WB_RegWrite&~MEM_Forward;
    assign ForwardSignal={MEM_Forward,WB_Forward};

endmodule
