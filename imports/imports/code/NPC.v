`include "ctrl_encode_def.v"

module NPC(EX_PC,PC, NPCOp, IMM, NPC,aluout);  // next pc module
   input [31:0] EX_PC;
   input  [31:0] PC;        // pc
   input  [2:0]  NPCOp;     // next pc operation
   input  [31:0] IMM;       // immediate should be MEM stage immout
	input [31:0] aluout;
   output reg [31:0] NPC;   // next pc
   
   wire [31:0] PCPLUS4;
   
   assign PCPLUS4 = PC + 4; // pc + 4
   
   always @(*) begin
      case (NPCOp)
          `NPC_PLUS4:  NPC = PCPLUS4;//3'b000
          `NPC_BRANCH: NPC = EX_PC+IMM;//3'b001
          `NPC_JUMP:   NPC = EX_PC+IMM;//3'b010
		  `NPC_JALR:	NPC =aluout;//3'b100
          default:     NPC = PCPLUS4;
      endcase
   end // end always
   
endmodule
