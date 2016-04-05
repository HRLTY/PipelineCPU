module Reg #(parameter width = 32)
   (input clk,reset,den,
    input [width-1 : 0]     dIn,
    output reg [width-1 :0] dOut);
   always @(posedge clk )
     begin
        if(reset)
          dOut <= 0;
        else
          if(!den)
            dOut <= dIn;
     end
endmodule // Reg

module PC (input clk,reset,denPC,
           input [31 :0]     dIn,
           output reg [31:0] dOut);
   always @(posedge clk or posedge reset)
     begin
        if(reset)
          dOut <= 32'h0000_3000;
        else
          if(!denPC)
            dOut <= dIn;
     end
endmodule // PC
