# PipelineCPU

This is a Verilog HDL implementation of a 5-stage pipeline CPU of MIPS architecture.

######If you have any question, feel free to reach me at huangruiwizard@gmail.com.

The CPU can support 50+ instructions:

MIPS-C3={LB、LBU、LH、LHU、LW、SB、SH、SW、ADD、ADDU、SUB、SUBU、MULT、MULTU、DIV、DIVU、SLL、SRL、SRA、SLLV、 SRLV、SRAV、AND、OR、XOR、NOR、ADDI、ADDIU、ANDI、ORI、 XORI、LUI、SLT、SLTI、SLTIU、SLTU、BEQ、BNE、BLEZ、BGTZ、 BLTZ、BGEZ、J、JAL、JALR、JR、MFHI、MFLO、MTHI、MTLO}

The files are tested on ISE 14.7.

Bonus: The Logisim implementations of the MIPS lite(in single sycle) and lite2 (in pipeline) are also provieded for visualization.

Note:

The overview of the 5-stage pipeline is presented in `PipelineOverview.png`.

The top structure of the Verilog HDL implementation is in `mips-pipeline-top.v`.

The essence of the pipeline is in `StallAndHazardUnit.v`.

License:

Copyright (C) 2016 by Rui Huang huangruiwizard@gmail.com

The program PipelineCPU is licensed under the GNU General Public License.

PipelineCPU is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

PipelineCPU is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with PipelineCPU. If not, see http://www.gnu.org/licenses/.
