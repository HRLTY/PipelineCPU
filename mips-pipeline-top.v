`include"defines.v"
`timescale 1us / 1ns


module mips();
//initial
reg clk,reset;
always #1 clk = ~clk;  
	reg [15:0] i;
	initial 
	begin
		clk = 0;
		reset = 1;
		#3;
      reset = 0;		
		for(i = 0;i <= 31; i = i+1)
			rf.rf[i] = 32'b0;
		for(i = 0;i <= 2047; i = i+1)
			dmem.mem[i] = 32'b0;
	end
	
	
//declarations
  //IF Unit
  wire [31:0] instr,pc,readdata;
	//IF_ID pipelineRegisters
   wire      IF_ID_den;
   wire [31:0] instr_D,pc4_D;
  //ID Unit
   wire [31:0] next_pc,npcOut,extOut,RD1,RD2;
   wire [1:0]  PCSel;
   wire       npcOp,extOp,cmpResult;
   wire [2:0] cmpOp;
   
	 //ID_EX pipelineRegisters
   wire       IR_E_Clear;
   wire [31:0] instr_E,pc8_E,rs_E,rt_E,ext_E;
	//EX Unit
   wire [31:0] ALUrdA,ALUrdB,ALUOut,RDHI,RDLO,EXOut;
   wire        ASel,BSel,start,mulWe,HiLo,busy,overflow;
   wire [3:0]  ALUOp;
   wire [1:0]  ALUSel,mulOp;
   //EX_MEM pipelineRegisters
   wire [31:0] instr_M,pc8_M,rt_M,ALUOut_M,rData;
   //MEM Unit
   wire       memWr;
   wire [1:0] BEextOp;
   wire [3:0] BE;
   //MEM_WB pipelineRegisters
   wire [31:0] instr_W,pc8_W,ALUOut_W,rData_W,wDataReg_W;
   wire [4:0]  wrRegNu_W;
	//WB Unit
   wire [31:0] WBextOut;
   wire [1:0]  WDSel,WRSel;
   wire [2:0]  WBextOp;
   wire        regWr;
   //Foward Unit and stall
   wire [1:0]  FowardRSD,FowardRTD,FowardRSE,FowardRTE; //foward signals
   wire        FowardRTM,stall;
   wire [31:0] FDRSD,FDRTD,FDRSEE,FDRTE,FDRTM; //foward data 
   
   //--------FUNCTION UNITS BEGIN HERE!-------------
   HazardUnit hazardUnit(instr_D,instr_E,instr_M,instr_W,
                         FowardRSD,FowardRTD,FowardRSE,FowardRTE,FowardRTM);
   StallUnit stallUnit(instr_D,instr_E,instr_M,busy,start,stall);
   //IF Unit
   PC pcReg(clk,reset,stall,next_pc,pc);//should be denPC
   rom imem(pc[11:2],instr);
	  
   //IF_ID pipelineRegisters
   Reg        IR_DReg(clk,reset,stall,instr,instr_D); //IF_ID_den
   Reg        PC4_DReg(clk,reset,stall,pc+32'b100,pc4_D);//IF_ID_den
   //ID Unit
   mux4 MFRSD(RD1,ALUOut_M,pc8_M,32'b0,FowardRSD,FDRSD);
   mux4 MFRTD(RD2,ALUOut_M,pc8_M,32'b0,FowardRTD,FDRTD);
   regfile rf(clk,regWr,instr_D[`RS],instr_D[`RT],wrRegNu_W,wDataReg_W,RD1,RD2);
   EXT ext(instr_D[15:0],extOp,extOut);
   CMP cmp(FDRSD,FDRTD,cmpOp,cmpResult);
   NPC npc(pc4_D,instr_D[25:0],npcOp,npcOut);
   mux4 M1(pc+32'b100,npcOut,FDRSD,32'b0,PCSel[1:0],next_pc);
   Control_ID control_ID(instr_D[31:0],cmpResult,PCSel[1:0],npcOp,extOp,cmpOp);
	
   //ID_EX pipelineRegisters
   Reg        IR_EReg(clk,(reset || stall),1'b0,instr_D,instr_E);//IR_E_Clear
   Reg        PC8_EReg(clk,reset,1'b0,pc4_D+32'b100,pc8_E);
   Reg        RS_EReg(clk,reset,1'b0,FDRSD,rs_E);
   Reg        RT_EReg(clk,reset,1'b0,FDRTD,rt_E);
   Reg        extReg(clk,reset,1'b0,extOut,ext_E);
   //EX Unit
   mux4 MFRSE(rs_E,ALUOut_M,pc8_M,wDataReg_W,FowardRSE,FDRSEE);
   mux4 MFRTE(rt_E,ALUOut_M,pc8_M,wDataReg_W,FowardRTE,FDRTE);
   
   Control_E control_E(instr_E,ALUOp,ASel,BSel,start,mulWe,HiLo,ALUSel,mulOp);
   mux2 aluSrcBMux(FDRTE,ext_E,BSel,ALUrdB);
   mux2 aluSrcAMux(FDRSEE,{27'b0,instr_E[`SHIFT]},ASel,ALUrdA);
   mux4 aluMux(ALUOut,32'b0,RDLO,RDHI,ALUSel,EXOut);
   ALU alu(ALUrdA,ALUrdB,ALUOp,ALUOut,overflow);
   MulDiv muldiv(FDRSEE,FDRTE,clk,reset,start,mulWe,HiLo,mulOp,busy,RDHI,RDLO);
   //EX_MEM pipelineRegisters
   Reg        IR_MReg(clk,reset,1'b0,instr_E,instr_M); 
   Reg        PC8_MReg(clk,reset,1'b0,pc8_E,pc8_M);
   Reg        RT_MReg(clk,reset,1'b0,FDRTE,rt_M);
   Reg        ALUOutReg_M(clk,reset,1'b0,EXOut,ALUOut_M);
   
   
   //MEM Unit
   mux2 MFRTM(rt_M,wDataReg_W,FowardRTM,FDRTM);
   Control_M control_M(instr_M,memWr,BEextOp);
   ram dmem(clk,memWr,ALUOut_M[12:2],BE,FDRTM,rData);
   BEext beext(ALUOut_M[1:0],BEextOp,BE);
   

	 //MEM_WB pipelineRegisters
   Reg        IR_WReg(clk,reset,1'b0,instr_M,instr_W);
   Reg        PC8_WReg(clk,reset,1'b0,pc8_M,pc8_W);
   Reg        ALUOutReg_W(clk,reset,1'b0,ALUOut_M,ALUOut_W);
   Reg        rDataReg(clk,reset,1'b0,rData,rData_W);
   //WB Unit
   WBext wbext(ALUOut_W[1:0],rData_W,WBextOp,WBextOut);
   Control_W control_W(instr_W,WRSel,WDSel,regWr,WBextOp);
   mux4 #(5) wrRegMux(instr_W[`RT] ,instr_W[`RD],5'h1f,5'b0,WRSel,wrRegNu_W);
   mux4 wrDataRegMux(ALUOut_W,WBextOut,pc8_W,32'b0,WDSel,wDataReg_W);
   
endmodule // mips







