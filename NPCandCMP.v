module NPC(input [31:0] PC4_D,
           input [25:0]  I26,
           input         NPCOp,// 0 indicate Branch,1 indicate J,Jal,Jalr
           output reg [31:0] next_pc);
   always @(*)
     begin
        if(!NPCOp)
          next_pc <= PC4_D + {{14{I26[15]}},I26[15:0],2'b00};
        else
          next_pc <= {PC4_D[31:28],I26[25:0],2'b00};
     end
   
endmodule // NPC

module CMP(input [31:0] a,b,
           input [2:0] cmpOp,
           output reg  result);//1 indecate taken
   reg [31:0]         c;
   always @(*)
      case(cmpOp)
        3'b000://beq
          begin
             c = a ^ b;
             result = ~(|c);		
          end
        3'b001://bne
          begin
             c = a ^ b;
             result = |c;
          end
        3'b100: result = !a[31];//bgez
        3'b101: result = !a[31] && a != 32'b0;//bgtz
        3'b110: result = a[31] || a == 32'b0; //blez
        3'b111: result = a[31];//bltz
      endcase // case (cmpOp)
endmodule // CMP

        
          
