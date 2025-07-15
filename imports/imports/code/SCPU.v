
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Tue Jun 20 18:23:52 2023
// Host        : LAPTOP-E4IJ843E running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub C:/Users/user/Desktop/projects/edf_file/SCPU.v
// Design      : SCPU
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
`include "../code/ctrl_encode_def.v"
module SCPU(clk, reset, MIO_ready, inst_in, Data_in, mem_w, 
  PC_out, Addr_out, Data_out, dm_ctrl, CPU_MIO, INT,SEPC_out,SCAUSE_out);
  input clk;
  input reset;
  input MIO_ready;
  input [31:0]inst_in;//fetched instruction
  input [31:0]Data_in;//data read from memory 

  output mem_w;//should be MEM stage

  output [31:0]PC_out;

  //following 3 output is used by dm_controller, so should be MEM stage value
  output [31:0]Addr_out;//should be MEM stage-aluout: memory address
  output [31:0]Data_out;
  output [2:0]dm_ctrl;

  output [31:0] SEPC_out;
  output [7:0] SCAUSE_out;

  output CPU_MIO;
  input INT;//作为外部中断信号，开�?14置位则进入循环，14复位则恢复到原指令执�?
      wire        RegWrite;    // control signal to register write
    wire [5:0]       EXTOp;       // control signal to signed extension
    wire [4:0]  ALUOp;       // ALU opertion
    wire [2:0]  NPCOp;       // next PC operation

    wire [1:0]  WDSel;       // (register) write data selection
    wire [1:0]  GPRSel;      // general purpose register selection
   
    wire        ALUSrc;      // ALU source for A
    wire        Zero;        // ALU ouput zero

    wire [31:0] NPC;         // next PC

    wire [4:0]  rs1;          // rs
    wire [4:0]  rs2;          // rt
    wire [4:0]  rd;          // rd
    wire [6:0]  Op;          // opcode
    wire [6:0]  Funct7;       // funct7
    wire [2:0]  Funct3;       // funct3
    wire [11:0] Imm12;       // 12-bit immediate
    wire [31:0] Imm32;       // 32-bit immediate
    wire [19:0] IMM;         // 20-bit immediate (address)
    wire [4:0]  A3;          // register address for write
    reg [31:0] WD;          // register write datp'c
    wire [31:0] RD1,RD2;         // register data specified by r
    
    wire [31:0] A; //operator for ALU A
    wire [31:0] B;           // operator for ALU B
	
	wire [4:0] iimm_shamt;
	wire [11:0] iimm,simm,bimm;
	wire [19:0] uimm,jimm;
	wire [31:0] immout;
wire[31:0] aluout;

wire [6:0] ID_Op;
wire [6:0] ID_Funct7;
wire [2:0] ID_Funct3;
wire [4:0] ID_rs1;
wire [4:0] ID_rs2;
wire [4:0] ID_rd;
wire [4:0] ID_Imm12;
wire [19:0] ID_IMM;

wire ID_sbtype;

wire ID_mem_w;

wire [2:0] ID_dm_ctrl;

wire ID_MemRead;

wire IF_ID_write_enable;
wire ID_EX_write_enable;
wire EX_MEM_write_enable;
wire MEM_WB_write_enable;
wire IF_ID_flush;
wire ID_EX_flush;
wire EX_MEM_flush; 
wire MEM_WB_flush;
wire [299:0]IF_ID_in,ID_EX_in,EX_MEM_in,MEM_WB_in;
wire [299:0]IF_ID_out,ID_EX_out,EX_MEM_out,MEM_WB_out;

wire [31:0] ID_instruction;
wire [31:0] ID_pcplus4;

wire [31:0] EX_pcplus4;
wire [31:0] EX_instruction;
wire [31:0] EX_immout;
wire [31:0] EX_RD1;
wire [31:0] EX_RD2;
wire EX_MemRead;

wire EX_ALUSrc;
wire [4:0] EX_ALUOp;

wire EX_mem_w;

wire [1:0] EX_WDSel;

wire [4:0] EX_rs1;
wire [4:0] EX_rs2;
wire [4:0] EX_rd;

wire [4:0] MEM_rd;
wire [3:0] MEM_PC_result;
wire MEM_Zero;
wire [31:0]MEM_aluout;
wire [31:0]MEM_rs2_data;
wire [2:0] MEM_dm_ctrl;
wire MEM_RegWrite;
wire MEM_mem_w;
wire [31:0] MEM_RD2;
wire [2:0] MEM_NPCOp;
wire [31:0] MEM_immout;
wire [31:0] MEM_pcplus4;

wire [2:0] EX_NPCOp;
wire Branch_or_Jump;

wire [31:0] WB_readData;
wire [4:0] WB_rd;
wire [31:0] WB_aluout;
wire WB_RegWrite;
wire [1:0] WB_WDSel;
wire[31:0] WB_pcplus4;

wire [1:0] ForwardSignalA;
wire [1:0] ForwardSignalB;

wire PCWrite;

wire stall_signal;

wire [31:0]RD2_forwarded;

wire [7:0]EX_SCAUSE;

wire int_signal;

wire overflow;
wire ERET;
wire ERETN;

reg [31:0] SEPC;
reg [7:0] SCAUSE;
reg [7:0] INTMASK=8'hff;

always @(negedge clk or posedge reset) begin
    if (reset) begin
        SEPC <= 32'h00000000;
        SCAUSE <= 8'h00;
        INTMASK <= 8'hff;
    end
    else 

    begin
      SEPC<=
    int_signal?(EX_pcplus4-4):SEPC;
    SCAUSE<=
    int_signal?EX_SCAUSE:SCAUSE;
    end

end

assign ERET=(EX_instruction==32'h01111111);
assign ERETN=(EX_instruction==32'h11111111);
assign int_signal=(EX_SCAUSE!=8'h00);

assign EX_SCAUSE=
overflow?8'h01:
(EX_instruction==32'h0011_1111)?8'h03://syscall
(EX_instruction==32'h1111_0000)?8'h04://undefined instruction
8'h00;



assign SEPC_out=SEPC;
assign SCAUSE_out=SCAUSE;

assign RD2_forwarded=
(ForwardSignalB==2'b00)?EX_RD2:
(ForwardSignalB==2'b01)?WD:
(ForwardSignalB==2'b10)?MEM_aluout:
32'b0;

//modify
// assign Addr_out=aluout;
assign Addr_out=MEM_aluout;

assign A=
(ForwardSignalA==2'b00)?EX_RD1:
(ForwardSignalA==2'b01)?WD:
(ForwardSignalA==2'b10)?MEM_aluout:
32'b0;

	// assign B = (EX_ALUSrc) ? EX_immout : EX_RD2;
  assign B=
  (EX_ALUSrc)?EX_immout:
  (ForwardSignalB==2'b00)?EX_RD2:
  (ForwardSignalB==2'b01)?WD:
(ForwardSignalB==2'b10)?MEM_aluout:
32'b0;

	assign Data_out = MEM_RD2;
	
	// assign iimm_shamt=inst_in[24:20];
	// assign iimm=inst_in[31:20];
	// assign simm={inst_in[31:25],inst_in[11:7]};
	// assign bimm={inst_in[31],inst_in[7],inst_in[30:25],inst_in[11:8]};
	// assign uimm=inst_in[31:12];
	// assign jimm={inst_in[31],inst_in[19:12],inst_in[20],inst_in[30:21]};
  assign iimm_shamt=ID_instruction[24:20];
  assign iimm=ID_instruction[31:20];
  assign simm={ID_instruction[31:25],ID_instruction[11:7]};
  assign bimm={ID_instruction[31],ID_instruction[7],ID_instruction[30:25],ID_instruction[11:8]};
  assign uimm=ID_instruction[31:12];
  assign jimm={ID_instruction[31],ID_instruction[19:12],ID_instruction[20],ID_instruction[30:21]};
   
    // assign Op = inst_in[6:0];  // instruction
    // assign Funct7 = inst_in[31:25]; // funct7
    // assign Funct3 = inst_in[14:12]; // funct3
    // assign rs1 = inst_in[19:15];  // rs1
    // assign rs2 = inst_in[24:20];  // rs2
    // assign rd = inst_in[11:7];  // rd
    // assign Imm12 = inst_in[31:20];// 12-bit immediate
    // assign IMM = inst_in[31:12];  // 20-bit immediate
    assign Op=ID_instruction[6:0];
    assign Funct7=ID_instruction[31:25];
    assign Funct3=ID_instruction[14:12];
    assign rs1=ID_instruction[19:15];
    assign rs2=ID_instruction[24:20];
    assign rd=ID_instruction[11:7];
    assign Imm12=ID_instruction[31:20];
    assign IMM=ID_instruction[31:12];

    assign ID_Op=ID_instruction[6:0];
    assign ID_Funct7=ID_instruction[31:25];
    assign ID_Funct3=ID_instruction[14:12];
    assign ID_rs1=ID_instruction[19:15];
    assign ID_rs2=ID_instruction[24:20];
    assign ID_rd=ID_instruction[11:7];
    assign  ID_Imm12=ID_instruction[31:20];
    assign  ID_IMM=ID_instruction[31:12];
   
   // instantiation of control unit
	// ctrl U_ctrl(
	// 	.Op(Op), .Funct7(Funct7), .Funct3(Funct3), .Zero(Zero), 
	// 	.RegWrite(RegWrite), .MemWrite(mem_w),
	// 	.EXTOp(EXTOp), .、�?�UOp(ALUOp), .NPCOp(NPCOp), 
	// 	.ALUSrc(ALUSrc), .GPRSel(GPRSel), .WDSel(WDSel),.DMType(dm_ctrl)
	// );

   assign dm_ctrl=MEM_dm_ctrl;
   assign mem_w=MEM_mem_w;

  ctrl U_ctrl
  (
    .Op(ID_Op),
    .Funct7(ID_Funct7),
    .Funct3(ID_Funct3),

    .RegWrite(RegWrite),
    .MemWrite(ID_mem_w),
    .EXTOp(EXTOp),
    .ALUOp(ALUOp),
    .NPCOp(NPCOp),//dispose judge next pc address at MEM stage
    .ALUSrc(ALUSrc),
    .GPRSel(GPRSel),
    .WDSel(WDSel),
    .DMType(ID_dm_ctrl),
    .MemRead(ID_MemRead)
  );

// instantiation of alu unit
	alu U_alu(.A(A), .B(B), .ALUOp(EX_ALUOp), .C(aluout), .Zero(Zero), .PC(EX_pcplus4-4),.overflow(overflow));

//please connnect the CPU by yourself

// always @*
// begin
// 	case(WDSel)
// 		`WDSel_FromALU: WD<=aluout;
// 		`WDSel_FromMEM: WD<=Data_in;
// 		`WDSel_FromPC: WD<=PC_out+4;
// 	endcase
// end


//GRE_array registers
/********************************************/
//IF/ID: 
//31-0:instruction 
//63-32:PC
/********************************************/
//ID/EX:
//63-32:PC
//100-96:instruction[11:7](write register:rd)
//104-101:instruction[30],instruction[14:12]
//136-105:立即数immout
//168-137:rs1 data
//200-169:rs2 data

//277:MemWrite
//278:RegWrite
//280:279:WDSel
//283:281:DMType

//288:284:rs1
//293:289:rs2
//298:294:rd

//299: MemRead

//300: sbtype

//EX
//201:ALUSrc
//206:202:ALUOp

//Mem
//207:MemWrite(mem_w)
//MemRead 不需要这个控制信息，从memory读到的数据就是scpu输入的Data_in
//210:208 branch(NpcOp)三位

//WB
//212:211MemtoReg(WDSel)两位
/********************************************/
//EX/MEM
//100-96:instruction[11:7](write register:rd)
//63-32:PC result
//244:213:aluout
//245:Zero flag
//200-169:rs2 data
/********************************************/
//MEM/WB
//63-32:PC result
//244:213:aluout
//100-96:instruction[11:7](write register:rd)
//276:245:read data from memory

assign PCWrite=~stall_signal;

assign IF_ID_flush=Branch_or_Jump|int_signal|ERET|ERETN;
assign IF_ID.write_enable=~(stall_signal);

assign ID_EX_flush=Branch_or_Jump|stall_signal|int_signal|ERET|ERETN;
assign ID_EX_write_enable=1'b1;

assign EX_MEM_flush=1'b0;
assign EX_MEM_write_enable=~int_signal|ERET|ERETN;

assign MEM_WB_flush=1'b0;
assign MEM_WB_write_enable=1'b1;



//IF/ID
assign ID_instruction=IF_ID_out[31:0];
assign  ID_pcplus4=IF_ID_out[63:32];

assign IF_ID.in[31:0]=inst_in;
assign IF_ID.in[63:32]=U_NPC.PCPLUS4;

//ID/EX
assign  EX_pcplus4=ID_EX_out[63:32];
assign  EX_instruction=ID_EX_out[31:0];
assign  EX_immout=ID_EX_out[136:105];
assign  EX_RD1=ID_EX_out[168:137];
assign  EX_RD2=ID_EX_out[200:169];

assign EX_MemRead=ID_EX_out[299];

assign EX_ALUSrc=ID_EX_out[201];
assign EX_ALUOp=ID_EX_out[206:202];

assign EX_mem_w=ID_EX_out[207];

assign EX_WDSel=ID_EX_out[212:211];

assign EX_NPCOp={ID_EX_out[210:209],ID_EX_out[208]&Zero};

assign  EX_rs1=ID_EX_out[288:284];
assign  EX_rs2=ID_EX_out[293:289];
assign  EX_rd=ID_EX_out[298:294];

assign ID_EX_in[63:32]=ID_pcplus4;
assign ID_EX_in[63:32]=IF_ID.out[63:32];
assign ID_EX_in[100:96]=ID_instruction[11:7];
assign ID_EX_in[104:101]={ID_instruction[30],ID_instruction[14:12]};
assign ID_EX_in[136:105]=immout;
assign ID_EX_in[168:137]=RD1;
assign ID_EX_in[200:169]=RD2;

assign ID_EX_in[201]=ALUSrc;
assign ID_EX_in[206:202]=ALUOp;

assign ID_EX_in[207]=ID_mem_w;
assign ID_EX_in[210:208]=NPCOp;

assign ID_EX_in[212:211]=WDSel;

//MemWrite and RegWrite
assign ID_EX_in[277]=ID_mem_w;
assign ID_EX_in[278]=RegWrite;
assign ID_EX_in[280:279]=WDSel;
assign ID_EX_in[283:281]=ID_dm_ctrl;

assign ID_EX_in[299]=ID_MemRead;

//
assign ID_EX_in[288:284]=ID_rs1;
assign ID_EX_in[293:289]=ID_rs2;
assign ID_EX_in[298:294]=ID_rd; 

assign ID_EX_in[31:0]=IF_ID_out[31:0];

//


//EX/MEM
assign MEM_rd=EX_MEM_out[100:96];
assign MEM_PC_result=EX_MEM_out[95:32];
assign MEM_Zero=EX_MEM_out[245];
assign MEM_aluout=EX_MEM_out[244:213];
assign MEM_rs2_data=EX_MEM_out[200:169];
assign MEM_rd=EX_MEM_out[100:96];
assign MEM_dm_ctrl=EX_MEM_out[283:281];
assign MEM_RegWrite=EX_MEM_out[278];
assign MEM_mem_w=EX_MEM_out[277];
assign MEM_RD2=EX_MEM_out[200:169];
assign MEM_NPCOp=EX_MEM_out[210:208];
assign MEM_immout=EX_MEM_out[136:105];
assign MEM_pcplus4=EX_MEM_out[63:32];

assign Branch_or_Jump=|EX_NPCOp;

assign EX_MEM_in[63:32]=ID_EX_out[63:32];
assign EX_MEM_in[100:96]=ID_EX_out[100:96];
assign EX_MEM_in[244:213]=aluout;
assign EX_MEM_in[245]=Zero;
assign EX_MEM_in[200:169]=RD2_forwarded;
assign EX_MEM_in[31:0]=ID_EX_out[31:0];

assign EX_MEM_in[277]=ID_EX_out[277];
assign EX_MEM_in[278]=ID_EX_out[278];
assign EX_MEM_in[280:279]=ID_EX_out[280:279];
assign EX_MEM_in[283:281]=ID_EX_out[283:281];

assign EX_MEM_in[288:284]=ID_EX_out[288:284];
assign EX_MEM_in[293:289]=ID_EX_out[293:289];
assign EX_MEM_in[298:294]=ID_EX_out[298:294];

assign EX_MEM_in[299]=ID_EX_out[299];

//
assign EX_MEM_in[210:208]=EX_NPCOp;

//
assign EX_MEM_in[136:105]=ID_EX_out[136:105];//immout


//MEM/WB
assign WB_readData=MEM_WB_out[276:245];
assign WB_rd=MEM_WB_out[298:294];
assign WB_aluout=MEM_WB_out[244:213];
assign WB_RegWrite=MEM_WB_out[278];
assign WB_WDSel=MEM_WB_out[280:279];
assign WB_pcplus4=MEM_WB_out[65:32];

assign MEM_WB_in[244:213]=EX_MEM_out[244:213];
assign MEM_WB_in[100:96]=EX_MEM_out[100:96];
assign MEM_WB_in[276:245]=Data_in;
assign MEM_WB_in[31:0]=EX_MEM_out[31:0];
assign MEM_WB_in[63:32]=EX_MEM_out[63:32];

assign MEM_WB_in[277]=EX_MEM_out[277];
assign MEM_WB_in[278]=EX_MEM_out[278];
assign MEM_WB_in[280:279]=EX_MEM_out[280:279];

assign MEM_WB_in[298:294]=EX_MEM_out[298:294];






GRE_array #(.WIDTH(300)) IF_ID(
  .clk(clk),
  .rst(reset),
  .write_enable(IF_ID_write_enable),
  .flush(IF_ID_flush),
  .in(IF_ID_in),

  .out(IF_ID_out));
GRE_array #(.WIDTH(300)) ID_EX(
  .clk(clk),
  .rst(reset),
  .write_enable(ID_EX_write_enable),
  .flush(ID_EX_flush),
  .in(ID_EX_in),
  
  .out(ID_EX_out));
GRE_array #(.WIDTH(300)) EX_MEM(
  .clk(clk),
  .rst(reset),
  .write_enable(EX_MEM_write_enable),
  .flush(EX_MEM_flush),
  .in(EX_MEM_in),

  .out(EX_MEM_out));
GRE_array #(.WIDTH(300)) MEM_WB(
  .clk(clk),
  .rst(reset),
  .write_enable(MEM_WB_write_enable),
  .flush(MEM_WB_flush),
  .in(MEM_WB_in),

  .out(MEM_WB_out));

HazardDetectionUnit hazard(
  .EX_MemRead(EX_MemRead),//to do
  .ID_rs1(ID_rs1),
  .ID_rs2(ID_rs2),
  .EX_rd(EX_rd),

  .stall_signal(stall_signal)
);

ForwardingUnit forwardA(
  .MEM_RegWrite(MEM_RegWrite),
  .MEM_rd(MEM_rd),
  .WB_RegWrite(WB_RegWrite),
  .WB_rd(WB_rd),
  .EX_rs(EX_rs1),

  .ForwardSignal(ForwardSignalA)
);
ForwardingUnit forwardB(
  .MEM_RegWrite(MEM_RegWrite),
  .MEM_rd(MEM_rd),
  .WB_RegWrite(WB_RegWrite),
  .WB_rd(WB_rd),
  .EX_rs(EX_rs2),

  .ForwardSignal(ForwardSignalB)
);

 // instantiation of pc unit
	PC U_PC(.PCWrite(PCWrite),.clk(clk), .rst(reset), .NPC(NPC), .PC(PC_out),.SEPC(SEPC),.int_signal(int_signal),.ERET(ERET),.ERETN(ERETN) );//to do
	NPC U_NPC(.EX_PC(EX_pcplus4-4),.PC(PC_out), .NPCOp(EX_NPCOp), .IMM(EX_immout), .NPC(NPC), .aluout(aluout));//to do
	EXT U_EXT(
		.iimm_shamt(iimm_shamt), .iimm(iimm), .simm(simm), .bimm(bimm),
		.uimm(uimm), .jimm(jimm),
		.EXTOp(EXTOp), .immout(immout)
	);
	RF U_RF(
		.clk(clk), .rst(reset),
		.RFWr(WB_RegWrite), 
		.A1(ID_rs1), .A2(ID_rs2), .A3(WB_rd), 

		.WD(WD), 
		.RD1(RD1), .RD2(RD2)
		//.reg_sel(reg_sel),
		//.reg_data(reg_data)
	);

always @*
begin
  case(WB_WDSel)
  `WDSel_FromALU:WD<=WB_aluout;
  `WDSel_FromMEM:WD<=WB_readData;
  `WDSel_FromPC:WD<=WB_pcplus4;
  endcase
end

endmodule
