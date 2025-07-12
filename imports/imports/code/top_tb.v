`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/28 09:34:11
// Design Name: 
// Module Name: top_tb
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


module top_tb();
    reg  clk, rstn;
    wire [4:0]btn_i;
    wire [15:0]sw_i;
    wire [7:0]disp_an_o;
    wire [7:0]disp_seg_o;
    wire [15:0]led_o;
    
    Top U_top(
	.clk(clk),
    .rstn(rstn),
    .btn_i(btn_i),
    .sw_i(sw_i),
    .disp_an_o(disp_an_o),
    .disp_seg_o(disp_seg_o),
    .led_o(led_o)
    );
    
    // 文件输出句柄
  	integer foutput;
  	// 仿真步数计数器
  	integer counter = 0;
  	
  	initial begin
      // 从文件加载指令到指令存储器
//      $readmemh("E:/cpu/summer/example/Test_8_Instr.dat", U_SCCOMP.U_IM.ROM);
      $monitor("PC = 0x%8X, instr = 0x%8X", 
	      U_top.PC_out, 
	      U_top.spo); // used for debug
      // 打开结果输出文件
      foutput = $fopen("results.txt");
      // 初始化信号
      clk = 1;
      rstn = 1;  // 初始复位无效
      #5 ;       // 等待5个时间单位
      // 激活复位信号
      rstn = 0;  // 复位有效
      #20 ;      // 保持20个时间单位
      // 释放复位信号
      rstn = 1;  // 复位无效
      // 运行1000个时间单位后设置寄存器选择
      #1000 ;
//      reg_sel = 7;  // 选择寄存器7
   end
   
   always begin
    #(50) clk = ~clk;
    
    if (clk == 1'b1) begin
      // 终止条件：达到最大步数或PC值变为未知
      if (U_top.PC_out === 32'hxxxxxxxx) begin
        $fclose(foutput);  // 关闭结果文件
        $stop;             // 停止仿真
      end
      else begin
        // 当PC达到特定地址0x48时（程序结束点）
        if (U_top.PC_out == 32'hxxxxxxxx) begin
          counter = counter + 1;  // 步数计数器递增
          // 将结果写入文件
          $fdisplay(foutput, "pc:\t %h", U_top.PC_out);
          $fdisplay(foutput, "instr:\t\t %h", U_top.spo);
          // 输出寄存器文件内容（分组显示）
          $fdisplay(foutput, "rf00-03:\t %h %h %h %h", 0, 
                    U_top.U1_SCPU.U_RF.rf[1], 
                    U_top.U1_SCPU.U_RF.rf[2], 
                    U_top.U1_SCPU.U_RF.rf[3]);
          $fdisplay(foutput, "rf04-07:\t %h %h %h %h", 
                    U_top.U1_SCPU.U_RF.rf[4], 
                    U_top.U1_SCPU.U_RF.rf[5], 
                    U_top.U1_SCPU.U_RF.rf[6], 
                    U_top.U1_SCPU.U_RF.rf[7]);
          $fdisplay(foutput, "rf08-11:\t %h %h %h %h", 
                    U_top.U1_SCPU.U_RF.rf[8], 
                    U_top.U1_SCPU.U_RF.rf[9], 
                    U_top.U1_SCPU.U_RF.rf[10], 
                    U_top.U1_SCPU.U_RF.rf[11]);
          $fdisplay(foutput, "rf12-15:\t %h %h %h %h", 
                    U_top.U1_SCPU.U_RF.rf[12], 
                    U_top.U1_SCPU.U_RF.rf[13], 
                    U_top.U1_SCPU.U_RF.rf[14], 
                    U_top.U1_SCPU.U_RF.rf[15]);
          $fdisplay(foutput, "rf16-19:\t %h %h %h %h", 
                    U_top.U1_SCPU.U_RF.rf[16], 
                    U_top.U1_SCPU.U_RF.rf[17], 
                    U_top.U1_SCPU.U_RF.rf[18], 
                    U_top.U1_SCPU.U_RF.rf[19]);
          $fdisplay(foutput, "rf20-23:\t %h %h %h %h", 
                    U_top.U1_SCPU.U_RF.rf[20], 
                    U_top.U1_SCPU.U_RF.rf[21], 
                    U_top.U1_SCPU.U_RF.rf[22], 
                    U_top.U1_SCPU.U_RF.rf[23]);
          $fdisplay(foutput, "rf24-27:\t %h %h %h %h", 
                    U_top.U1_SCPU.U_RF.rf[24], 
                    U_top.U1_SCPU.U_RF.rf[25], 
                    U_top.U1_SCPU.U_RF.rf[26], 
                    U_top.U1_SCPU.U_RF.rf[27]);
          $fdisplay(foutput, "rf28-31:\t %h %h %h %h", 
                    U_top.U1_SCPU.U_RF.rf[28], 
                    U_top.U1_SCPU.U_RF.rf[29], 
                    U_top.U1_SCPU.U_RF.rf[30], 
                    U_top.U1_SCPU.U_RF.rf[31]);
          //$fdisplay(foutput, "hi lo:\t %h %h", 
          //U_SCCOMP.U_SCPU.U_RF.rf.hi, 
          //U_SCCOMP.U_SCPU.U_RF.rf.lo);
          // 关闭文件并停止仿真
          $fclose(foutput);
          $stop;
        end
        else begin
          // 未到达结束点，继续运行
          counter = counter + 1;  // 步数计数器递增
//          $display("ctrl: %h", U_top.dm_ctrl);
//            $display("addra: 0x%8X", U_top.addra);
//            $display("Addr_in: 0x%8X", U_top.Addr_in);
//          $display("ram_data_in: %h", U_top.dina);
          $display("ram_data_out: %h", U_top.douta);
          //$display("pc: %h", U_SCCOMP.U_SCPU.PC);
          //$display("instr: %h", U_SCCOMP.U_SCPU.instr);
        end
      end
    end
  end // end always
endmodule
