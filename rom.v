module rom #(parameter N = 10,M = 32)
   (input [N-1:0] addr,
    output [M-1:0] dout);
   reg [M-1:0]     mem [2**N-1:0];
   initial
     $readmemh("memfile.dat",mem);
   assign dout = mem[addr];
endmodule // rom
