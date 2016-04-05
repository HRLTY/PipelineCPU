`define RS 25:21
`define RT 20:16
`define RD 15:11
`define OP 31:26
`define FUNC 5:0
`define SHIFT 10:6
//load and store
`define LB (instr[`OP] == 6'h20)
`define LBU (instr[`OP] == 6'h24)
`define LH (instr[`OP] == 6'h21)
`define LHU (instr[`OP] == 6'h25)
`define LW (instr[`OP] == 6'h23)
`define SB (instr[`OP] == 6'h28)
`define SH (instr[`OP] == 6'h29)
`define SW (instr[`OP] == 6'h2b)
//R-R cal
`define ADD (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h20)
`define ADDU (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h21)
`define SUB (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h22)
`define SUBU (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h23)

`define MULT (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h18)
`define MULTU (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h19)
`define DIV (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h1a)
`define DIVU (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h1b)

`define SLT (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h2a)
`define SLTU (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h2b)
`define SLL (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h0)
`define SRL (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h2)
`define SRA (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h3)
`define SLLV (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h4)
`define SRLV (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h6)
`define SRAV (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h7)
`define AND (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h24)
`define OR (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h25)
`define XOR (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h26)
`define NOR (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h27)
//R-I cal
`define ADDI (instr[`OP] == 6'h8)
`define ADDIU (instr[`OP] == 6'h9)
`define ANDI (instr[`OP] == 6'hc)
`define ORI (instr[`OP] == 6'hd)
`define XORI (instr[`OP] == 6'he)
`define LUI (instr[`OP] == 6'hf)
`define SLTI (instr[`OP] == 6'ha)
`define SLTIU (instr[`OP] == 6'hb)
//branch
`define BEQ (instr[`OP] == 6'h4)
`define BNE (instr[`OP] == 6'h5)
`define BLEZ (instr[`OP] == 6'h6)
`define BGTZ (instr[`OP] == 6'h7)
`define BLTZ (instr[`OP] == 6'h1 && instr[`RT] == 6'h0)
`define BGEZ (instr[`OP] == 6'h1 && instr[`RT] == 6'h1)
//jump
`define J (instr[`OP] == 6'h2)
`define JAL (instr[`OP] == 6'h3)
`define JALR (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h9)
`define JR (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h8)
//transport
`define MFHI (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h10)
`define MFLO (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h12)
`define MTHI (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h11)
`define MTLO (instr[`OP] == 6'h0 && instr[`FUNC] == 6'h13)
