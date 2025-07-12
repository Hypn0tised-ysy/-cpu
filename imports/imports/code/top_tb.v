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
    
    // �ļ�������
  	integer foutput;
  	// ���沽��������
  	integer counter = 0;
  	
  	initial begin
      // ���ļ�����ָ�ָ��洢��
//      $readmemh("E:/cpu/summer/example/Test_8_Instr.dat", U_SCCOMP.U_IM.ROM);
      $monitor("PC = 0x%8X, instr = 0x%8X", 
	      U_top.PC_out, 
	      U_top.spo); // used for debug
      // �򿪽������ļ�
      foutput = $fopen("results.txt");
      // ��ʼ���ź�
      clk = 1;
      rstn = 1;  // ��ʼ��λ��Ч
      #5 ;       // �ȴ�5��ʱ�䵥λ
      // ���λ�ź�
      rstn = 0;  // ��λ��Ч
      #20 ;      // ����20��ʱ�䵥λ
      // �ͷŸ�λ�ź�
      rstn = 1;  // ��λ��Ч
      // ����1000��ʱ�䵥λ�����üĴ���ѡ��
      #1000 ;
//      reg_sel = 7;  // ѡ��Ĵ���7
   end
   
   always begin
    #(50) clk = ~clk;
    
    if (clk == 1'b1) begin
      // ��ֹ�������ﵽ�������PCֵ��Ϊδ֪
      if (U_top.PC_out === 32'hxxxxxxxx) begin
        $fclose(foutput);  // �رս���ļ�
        $stop;             // ֹͣ����
      end
      else begin
        // ��PC�ﵽ�ض���ַ0x48ʱ����������㣩
        if (U_top.PC_out == 32'hxxxxxxxx) begin
          counter = counter + 1;  // ��������������
          // �����д���ļ�
          $fdisplay(foutput, "pc:\t %h", U_top.PC_out);
          $fdisplay(foutput, "instr:\t\t %h", U_top.spo);
          // ����Ĵ����ļ����ݣ�������ʾ��
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
          // �ر��ļ���ֹͣ����
          $fclose(foutput);
          $stop;
        end
        else begin
          // δ��������㣬��������
          counter = counter + 1;  // ��������������
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
