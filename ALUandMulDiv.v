module ALU(input [31:0] a,b,
           input [3:0]       ALUOp,
           output reg [31:0] ALUOut,
           output reg        over);//0 indicate no overflow
   always @(*)
     begin
        case (ALUOp)
          4'b00_00: ALUOut = a+b;    
          4'b00_01: ALUOut = a-b;   
          4'b00_10: ALUOut = {b[15:0],16'b0}; //lui
          
          4'b01_00: ALUOut = a & b; //and
          4'b01_01: ALUOut = a | b;  //or
          4'b01_10: ALUOut = a ^ b; //xor
          4'b01_11: ALUOut = ~(a | b); //nor
          
          4'b10_00: ALUOut = b<<a[4:0]; //{b[31-a[4:0]],{a[4:0]{1'b0}}};//left shift logic
          4'b10_10: ALUOut = b>>a[4:0];//{{a[4:0]{1'b0}},b[31:a[4:0]]};//right shift logic
          4'b10_11: ALUOut = $signed(b)>>>$signed(a[4:0]); //{{a[4:0]{b[31]}},b[31:a[4:0]]};//right shift arithmetic
          
          4'b11_00: ALUOut = $signed(a) < $signed(b) ? 32'b1 : 32'b0;//set less than
          4'b11_01: ALUOut = a < b ? 32'b1 : 32'b0; //set less than unsigned
        endcase // case (ALUOp)
        over <= 0;
     end
endmodule // ALU

module MulDiv(input [31:0] a,b,
              input         clk,reset,start,
              input         we,HiLo, //0->LO, 1->HI
              input [1:0]   MulOp,
              output reg busy,//1 indicate busy multiplying or dividing
              output reg [31:0] HI,LO);
   reg [3:0]                    count;
	reg [31:0] at,bt;
   always @(posedge clk)
     begin
	  	 $display("a=%8X,b=%8X,at=%8X,bt=%8X",a,b,at,bt);
        if(reset)
          begin
             HI <= 32'b0;
             LO <= 32'b0;
             count <= 0;
             busy <= 0;
          end
        if(we)
          if(HiLo)
            HI = a;
          else
            LO = a;
        else if(count == 1)
          begin
             if(MulOp == 2'b00)//multu
						{HI,LO} = at * bt;					
             else if(MulOp == 2'b01) //mult
               {HI,LO} = $signed(at)*$signed(bt);
             else if(MulOp == 2'b10) //divu
               begin
                  HI <= at % bt;
                  LO <= at / bt;
               end
             else if(MulOp == 2'b11) //div
               begin
                  HI <= $signed(at) % $signed(bt);
                  LO <= $signed(at) / $signed(bt);
               end
          end // if (count == 1)
        if(count)
          count = count - 4'b1;
        
        if(start)
          begin
             if(MulOp == 2'b00 || MulOp == 2'b01)
               count = 5;
             else
               count = 10;
				 at = a;
				 bt = b;
             busy = 1;
          end
        if(count)
          busy <= 1;
        else
          busy <= 0;
     end // always (posedge clk)
endmodule // MulDiv




             
             




