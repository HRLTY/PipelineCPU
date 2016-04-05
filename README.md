# PipelineCPU

This is a Verilog HDL implementation of a 5-stage pipeline CPU of MIPS architecture.

The CPU can support 50+ instructions:

MIPS-C3={LB、LBU、LH、LHU、LW、SB、SH、SW、ADD、ADDU、SUB、SUBU、MULT、MULTU、DIV、DIVU、SLL、SRL、SRA、SLLV、 SRLV、SRAV、AND、OR、XOR、NOR、ADDI、ADDIU、ANDI、ORI、 XORI、LUI、SLT、SLTI、SLTIU、SLTU、BEQ、BNE、BLEZ、BGTZ、 BLTZ、BGEZ、J、JAL、JALR、JR、MFHI、MFLO、MTHI、MTLO}

The files are tested on ISE 14.7.

Bonus: The Logisim implementations of the MIPS lite(in single sycle) and lite2 (in pipeline) are also provieded for visualization.

Note:

The overview of the 5-stage pipeline is presented in `PipelineOverview.png`.

The top structure of the SystemVerilog implementation is in `mips-pipeline-top.v`.