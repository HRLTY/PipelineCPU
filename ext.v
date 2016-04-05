module EXT(input [15:0] immIn,
           input ExtOp,
           output reg [31:0] immOut);
   always @(ExtOp or immIn)
     if(ExtOp)
       immOut <= {{16{immIn[15]}},immIn[15:0]};
     else
       immOut <= {16'b0,immIn[15:0]};
endmodule // ext
