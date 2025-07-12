`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/01 10:34:00
// Design Name: 
// Module Name: hazard_detection_unit
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


module HazardDetectionUnit(
    input EX_MemRead,
    input [4:0]ID_rs1,
    input [4:0]ID_rs2,
    input [4:0]EX_rd,
    output stall_signal
    );

    assign stall_signal=EX_MemRead&(~(|(EX_rd^ID_rs1))|~(|(EX_rd^ID_rs2)));

endmodule
