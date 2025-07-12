`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/01 10:34:00
// Design Name: 
// Module Name: GRE_array
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


module GRE_array #(parameter WIDTH=300)(
    input clk,rst,write_enable,flush,
    // input [0:WIDTH-1] in,
    // output reg[0:WIDTH-1] out 
    //modify
    input [WIDTH-1:0] in,
    output reg[WIDTH-1:0] out
    );

    // always@(negedge Clk)
    // begin 
    //     if(write_enable)
    //     begin 
    //         if(flush)
    //         out=0;
    //         else 
    //         out=in;
    //     end
    // end
    //modify 上升沿写 下降沿读
    always@(posedge clk or posedge rst)
    begin
        if(rst)begin
            out<=0;
        end
        else if(write_enable)
        begin
            if(flush)
            out<=0;
            else 
            out<=in;
        end
    end

endmodule
