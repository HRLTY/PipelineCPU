`include"defines.v"

module Control_ID(input [31:0] instr,
                  input            cmpResult,
                  output reg [1:0] PCSel,
                  output reg       npcOp,extOp,
                  output reg [2:0] cmpOp);
   
   always @(*)
     begin
        //handle PCSel and npcOp
        if((`BEQ || `BNE || `BLEZ || `BGTZ || `BLTZ || `BGEZ) && cmpResult)
          begin
             PCSel <= 2'b01;
             npcOp <= 1'b0;
          end
        else if(`J || `JAL) 
          begin
             PCSel <= 2'b01;
             npcOp <= 1'b1;
          end
        else if(`JR || `JALR)
          PCSel <= 2'b10;
        else //other than Branch and Jump
          PCSel <= 2'b0;
        
        //handle extOp
        if(`LB || `LBU || `LH || `LHU || `LW || `SB || `SH || `SW || `ADDI || `ADDIU || `SLTI || `SLTIU)
          extOp <= 1'b1;
        else
          extOp <= 1'b0;
        //handle cmpOp
        if(`BEQ)
          cmpOp = 3'b000;
        else if(`BNE)
          cmpOp = 3'b001;
        else if(`BGEZ)
          cmpOp = 3'b100;
        else if(`BGTZ)
          cmpOp = 3'b101;
        else if(`BLEZ)
          cmpOp = 3'b110;
        else if(`BLTZ)
          cmpOp = 3'b111;
     end // always @ (*)
endmodule // ConTrol_ID

module Control_E(input [31:0] instr,
                 output reg [3:0] ALUOp,
                 output reg       ASel,BSel,start,mulWe,HiLo,
                 output reg [1:0] ALUSel,mulOp);
   always @(*)
   begin
      //handle ALUOp
      if(`LUI)
        ALUOp = 4'b00_10;
      else if(`SUB || `SUBU)
        ALUOp = 4'b00_01;
      else if(`AND || `ANDI)
        ALUOp = 4'b01_00;
      else if(`OR || `ORI)
        ALUOp = 4'b01_01;
      else if(`XOR || `XORI)
        ALUOp = 4'b01_10;
      else if(`NOR)
        ALUOp = 4'b01_11;
      else if(`SLL || `SLLV)
        ALUOp = 4'b10_00;
      else if(`SRL || `SRLV)
        ALUOp = 4'b10_10;
      else if(`SRA || `SRAV)
        ALUOp = 4'b10_11;
      else if(`SLT || `SLTI)
        ALUOp = 4'b11_00;
      else if(`SLTU || `SLTIU)
        ALUOp = 4'b11_01;
      else //others use add
        ALUOp = 4'b00_00;

      //handle ASel and BSel
      if(`SLL || `SRL || `SRA)
        ASel = 2'b01;
      else
        ASel = 2'b00;
      if(`LB || `LBU || `LH || `LHU || `LW || `SB || `SH || `SW || `ADDI || `ADDIU || `ANDI || `ORI || `XORI || `LUI || `SLTI || `SLTIU)
        BSel = 2'b01;
      else
        BSel = 2'b00;
      //handle start and MulOp
      if(`MULT || `MULTU || `DIV || `DIVU)
        start = 1;
      else
        start = 0;
      if(`MULTU)
        mulOp = 2'b00;
      else if(`MULT)
        mulOp = 2'b01;
      else if(`DIVU)
        mulOp = 2'b10;
      else if(`DIV)
        mulOp = 2'b11;
      //handle HiLo and mulWe
      if(`MTHI)
        begin
           mulWe = 1;
           HiLo = 1;
        end
      else if(`MTLO)
        begin
           mulWe = 1;
           HiLo = 0;
        end
      else
        mulWe = 0;
      //handle ALUSel
      if(`MFHI)
        ALUSel = 2'b11;
      else if(`MFLO)
        ALUSel = 2'b10;
      else
        ALUSel = 2'b00;
   end
endmodule // Control_IE

module Control_M(input [31:0] instr,
                 output reg memWr,
                 output reg [1:0] BEextOp);
   always @(*)
             begin
   if(`SB || `SH || `SW)
     memWr = 1;
   else
     memWr = 0;

   if(`SH)
     BEextOp = 2'b10;
   else if(`SB)
     BEextOp = 2'b11;
   else
     BEextOp = 2'b00;
             end // always @ begin
   
endmodule // Control_M

module Control_W(input [31:0] instr,
                 output reg [1:0] WRSel,WDSel,
                 output reg       regWr,
                 output reg [2:0] WBextOp);
   always @(*)
                begin
                if(`LBU)
                  WBextOp = 3'b001;
                else if(`LB)
                  WBextOp = 3'b010;
                else if(`LHU)
                  WBextOp = 3'b011;
                else if(`LH)
                  WBextOp = 3'b100;
                else
                  WBextOp = 3'b000;

                   if(`ADD || `ADDU || `SUB || `SUBU || `SLT || `SLTU || `SLL || `SRL || `SRA || `SLLV || `SRLV || `SRAV || `AND || `OR || `XOR || `NOR || `MFHI || `MFLO) //r-r cal and MF
                               begin
                                  regWr <= 1'b1;
                                  WRSel <= 2'b01;//RD
                                  WDSel <= 2'b00;//ALU
                               end
                             else if(`JAL)
                               begin
                                  regWr <= 1'b1;
                                  WRSel <= 2'b10;//1f
                                  WDSel <= 2'b10;//pc8_W
                               end
                             else if(`JALR)
                               begin
                                  regWr <= 1'b1;
                                  WRSel <= 2'b01;//rd
                                  WDSel <= 2'b10;//pc8_W
                               end
                             else if(`LB || `LBU || `LH || `LHU || `LW) //load
                             begin
                                regWr <= 1'b1;
                                WRSel <= 2'b00;//rt
                                WDSel <= 2'b01; //rdata
                             end
                           else if(`ADDI || `ADDIU || `ANDI || `ORI || `XORI || `LUI || `SLTI || `SLTIU) //r-i cal
                             begin
                                regWr <= 1'b1;
                                WRSel <= 2'b00;//rt
                                WDSel <= 2'b00;//ALU
                             end
                           else //default
                             begin
                                regWr <= 1'b0;
                                WRSel <= 2'b00;
                                WDSel <= 2'b00;
                             end // 
                end // always @ begin
   
   endmodule // Control_W
