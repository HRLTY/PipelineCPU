`include"defines.v"
module StallUnit(input [31:0] instr_D,instr_E,instr_M,
                 input      busy,start,
                 output reg stall);

   always @(*)
     begin
	  if((busy || start) && (muldiv(instr_D) || mt(instr_D) || mf(instr_D)))
          stall <= 1'b1;
     else if(load(instr_E)) 
          begin
             if(beqbne(instr_D) && instr_E[`RT] == instr_D[`RT])
               stall <= 1'b1;
             else if(bjj(instr_D) && instr_E[`RT] == instr_D[`RS])
               stall <= 1'b1;
             else if(cal_r(instr_D) && instr_E[`RT] == instr_D[`RT])
               stall <= 1'b1;
             else if((cal_r(instr_D) || cal_i(instr_D) || load(instr_D) || store(instr_D) || mt(instr_D))  && instr_E[`RT] == instr_D[`RS])
               stall <= 1'b1;
             else 
               stall <= 1'b0;
          end // if (load(instr_E))
        else if(cal_i(instr_E)) //cal_i_E
          begin
             if(beqbne(instr_D) && instr_E[`RT] == instr_D[`RT])
               stall <= 1'b1;
             else if(bjj(instr_D) && instr_E[`RT] == instr_D[`RS]) 
               stall <= 1'b1;
             else 
               stall <= 1'b0;
          end
        else if(cal_r(instr_E) && instr_E[`RD] != 5'b0 || mt(instr_E)) //addu or subu_E
          begin
             if(beqbne(instr_D) && instr_E[`RD] == instr_D[`RT])
               stall <= 1'b1;
             else if(bjj(instr_D) && instr_E[`RD] == instr_D[`RS]) 
               stall <= 1'b1;
             else 
               stall <= 1'b0;
          end
        else if(load(instr_M))
          begin
             if(beqbne(instr_D) && instr_M[`RT] == instr_D[`RT])
               stall <= 1'b1;
             else if(bjj(instr_D) && instr_M[`RT] == instr_D[`RS]) 
               stall <= 1'b1;
             else 
               stall <= 1'b0;
          end
        else 
          stall <= 1'b0;
     end // always @ begin

function load;
   input [31:0] instr;
    load = (`LB || `LBU || `LH || `LHU || `LW);
endfunction // StallUnit

function beqbne;
   input [31:0] instr;
    beqbne = (`BEQ || `BNE);
endfunction // StallUnit

function bjj;//branch or Jr or Jalr
   input [31:0] instr;
    bjj  = (`BEQ || `BNE || `BLEZ || `BGTZ || `BLTZ || `BGEZ || `JALR || `JR);
endfunction // StallUnit

function cal_r;//include sll srl sra exclude mul div
   input [31:0] instr;
    cal_r = (`ADD || `ADDU || `SUB || `SUBU || `SLT || `SLTU || `SLL || `SRL || `SRA || `SLLV || `SRLV || `SRAV || `AND || `OR || `XOR || `NOR);
endfunction // StallUnit

function cal_i;//include lui
   input [31:0] instr;
    cal_i = (`ADDI || `ADDIU || `ORI || `XORI || `LUI || `SLTI || `SLTIU);
endfunction // StallUnit

function store;
   input [31:0] instr;
    store = (`SB || `SH || `SW);
endfunction // StallUnit

function muldiv;
   input [31:0] instr;
    muldiv = (`MULT || `MULTU || `DIV || `DIVU);
endfunction // StallUnit

function mt;
   input [31:0] instr;
    mt = (`MTHI || `MTLO);
endfunction // StallUnit

function mf;
   input [31:0] instr;
    mf = (`MFHI || `MFLO);
endfunction // StallUnit

function jal;
   input [31:0] instr;
    jal = `JAL;
endfunction // StallUnit
function jalr;
   input [31:0] instr;
    jalr = `JALR;
endfunction // StallUnit
   
endmodule // StallUnit

module HazardUnit(input [31:0] instr_D,instr_E,instr_M,instr_W,
                  output reg [1:0] FowardRSD,FowardRTD,FowardRSE,FowardRTE,
                  output reg       FowardRTM);

   always @(*)//for FowardRSD

                                          //if(bjj(instr_D))
     if((cal_r(instr_M) && instr_M[`RD] != 5'b0 || mf(instr_M)) && instr_M[`RD] == instr_D[`RS]) //cal_r M
       FowardRSD <= 2'b01;
     else if(cal_i(instr_M) && instr_M[`RT] == instr_D[`RS]) //cal_i M
       FowardRSD <= 2'b01;
     else if((jal(instr_M) && instr_D[`RS] == 5'h1f) || ( jalr(instr_M) && instr_D[`RS] == instr_M[`RD])) //jal M
       FowardRSD <= 2'b10;
     else
       FowardRSD <= 2'b00;
   //  else
   // FowardRSD <= 2'b00;

   
   
   always @(*) //for Foward RTD
                                                         //                if(beqbne(instr_D)) //beq D
     if((cal_r(instr_M) && instr_M[`RD] != 5'b0 || mf(instr_M)) && instr_M[`RD] == instr_D[`RT])
       FowardRTD <= 2'b01;
     else if(cal_i(instr_M) && instr_M[`RT] == instr_D[`RT])
       FowardRTD <= 2'b01;
     else if((jal(instr_M) && instr_D[`RT] == 5'h1f) || ( jalr(instr_M) && instr_D[`RT] == instr_M[`RD]))
       FowardRTD <= 2'b10;
     else
       FowardRTD <= 2'b00;
   //              else
   //                 FowardRTD <= 2'b00;


   always @(*) //for Foward RSE

                                                         //if(cal_r(instr_E) || cal_i(instr_E) || load(instr_E) || store(instr_E) || mt(instr_E) || muldiv(instr_E))//cal_i cal_r lw sw E
      
     if((cal_r(instr_M) && instr_M[`RD] != 5'b0 || mf(instr_M)) && instr_M[`RD] == instr_E[`RS]) //cal_r M
       FowardRSE <= 2'b01;
     else if(cal_i(instr_M) && instr_M[`RT] == instr_E[`RS]) //cal_i M
       FowardRSE <= 2'b01;
     else if((jal(instr_M) && instr_E[`RS] == 5'h1f) || (jalr(instr_M) && instr_E[`RS] == instr_M[`RD])) //jal M
       FowardRSE <= 2'b10;
   
     else if((cal_r(instr_W) && instr_W[`RD] != 5'b0 || mf(instr_W)) && instr_W[`RD] == instr_E[`RS]) //cal_r W
       FowardRSE <= 2'b11;
     else if(cal_i(instr_W) && instr_W[`RT] == instr_E[`RS]) //cal_i W
       FowardRSE <= 2'b11;
     else if(load(instr_W) && instr_W[`RT] == instr_E[`RS]) //load W
       FowardRSE <= 2'b11;
     else if((jal(instr_W) && instr_E[`RS] == 5'h1f) || (jalr(instr_W) && instr_E[`RS] == instr_W[`RD]))
       FowardRSE <= 2'b11;
     else
       FowardRSE <= 2'b00;
   
   //else
   //  FowardRSE <= 2'b00;

   always @(*) //for Foward RTE


                                                         //if(cal_r(instr_E) || store(instr_E) || muldiv(instr_E))//cal_i sw E
     if((cal_r(instr_M) && instr_M[`RD] != 5'b0 || mf(instr_M)) && instr_M[`RD] == instr_E[`RT]) //cal_r M
       FowardRTE <= 2'b01;
     else if(cal_i(instr_M) && instr_M[`RT] == instr_E[`RT]) //cal_i M
       FowardRTE <= 2'b01;
     else if((jal(instr_M) && instr_E[`RT] == 5'h1f) || (jalr(instr_M) && instr_E[`RT] == instr_M[`RD])) //jal M
       FowardRTE <= 2'b10;
   
     else if((cal_r(instr_W) && instr_W[`RD] != 5'b0 || mf(instr_W)) && instr_W[`RD] == instr_E[`RT]) //cal_r W
       FowardRTE <= 2'b11;
     else if(cal_i(instr_W) && instr_W[`RT] == instr_E[`RT]) //cal_i W
       FowardRTE <= 2'b11;
     else if(load(instr_W) && instr_W[`RT] == instr_E[`RT]) //load W
       FowardRTE <= 2'b11;
     else if((jal(instr_W) && instr_E[`RT] == 5'h1f) || (jalr(instr_W) && instr_E[`RT] == instr_W[`RD]))
       FowardRTE <= 2'b11;
     else
       FowardRTE <= 2'b00;

   //else
   //  FowardRTE <= 2'b00;
   
   always @(*) //for Foward RTM
                                                         //if(store(instr_M)) //sw M
     if((cal_r(instr_W) && instr_W[`RD] != 5'b0 || mf(instr_W)) && instr_W[`RD] == instr_M[`RT]) //cal_r W
       FowardRTM <= 1'b1;
     else if((cal_i(instr_W) || load(instr_W)) && instr_W[`RT] == instr_M[`RT]) //cal_i W
       FowardRTM <= 1'b1;
   
     else if((jal(instr_W) && instr_M[`RT] == 5'h1f) || (jalr(instr_W) && instr_W[`RD] == instr_M[`RT])) //jal W
       FowardRTM <= 1'b1;
     else
       FowardRTM <= 1'b0;
   //else
   //  FowardRTM <= 1'b0;   



function load;
   input [31:0] instr;
    load = (`LB || `LBU || `LH || `LHU || `LW);
endfunction // StallUnit

function beqbne;
   input [31:0] instr;
    beqbne = (`BEQ || `BNE);
endfunction // StallUnit

function bjj;//branch or Jr or Jalr
   input [31:0] instr;
    bjj  = (`BEQ || `BNE || `BLEZ || `BGTZ || `BLTZ || `BGEZ || `JALR || `JR);
endfunction // StallUnit

function cal_r;//include sll srl sra exclude mul div
   input [31:0] instr;
    cal_r = (`ADD || `ADDU || `SUB || `SUBU || `SLT || `SLTU || `SLL || `SRL || `SRA || `SLLV || `SRLV || `SRAV || `AND || `OR || `XOR || `NOR);
endfunction // StallUnit

function cal_i;//include lui
   input [31:0] instr;
    cal_i = (`ADDI || `ADDIU || `ORI || `XORI || `LUI || `SLTI || `SLTIU);
endfunction // StallUnit

function store;
   input [31:0] instr;
    store = (`SB || `SH || `SW);
endfunction // StallUnit

function muldiv;
   input [31:0] instr;
    muldiv = (`MULT || `MULTU || `DIV || `DIVU);
endfunction // StallUnit

function mt;
   input [31:0] instr;
    mt = (`MTHI || `MTLO);
endfunction // StallUnit

function mf;
   input [31:0] instr;
    mf = (`MFHI || `MFLO);
endfunction // StallUnit

function jal;
   input [31:0] instr;
    jal = `JAL;
endfunction // StallUnit
function jalr;
   input [31:0] instr;
    jalr = `JALR;
endfunction // StallUnit	
endmodule // HazardUnit
