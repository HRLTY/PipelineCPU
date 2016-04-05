module fulladder(input  a,b,cin,
                 output reg s,cout);
   reg                 p,g;
   always @(*)
     begin
        p = a^b;
        g = a&b;

        s = p ^ cin;
        cout = g | (p&cin);
     end
endmodule // fulladder

module adder_8b(input [7:0] a,b,input cin,
                output  cout, [7:0] sum);
  wire [7:0]                    c;
   assign cout = c[7];
   
   fulladder add0(a[0],b[0],cin,sum[0],c[0]);
   fulladder add1(a[1],b[1],c[0],sum[1],c[1]);
   fulladder add2(a[2],b[2],c[1],sum[2],c[2]);
   fulladder add3(a[3],b[3],c[2],sum[3],c[3]);
   fulladder add4(a[4],b[4],c[3],sum[4],c[4]);
   fulladder add5(a[5],b[5],c[4],sum[5],c[5]);
   fulladder add6(a[6],b[6],c[5],sum[6],c[6]);
   fulladder add7(a[7],b[7],c[6],sum[7],c[7]);
endmodule // adder_8b

module adder_32b(input [31:0] a,b,
                 output  cout,[31:0] sum);
   wire [3:0]              c;
   assign cout = c[3];
   adder_8b add0(a[7:0],b[7:0],1'b0,c[0],sum[7:0]);
   adder_8b add1(a[15:8],b[15:8],c[0],c[1],sum[15:8]);
   adder_8b add2(a[23:16],b[23:16],c[1],c[2],sum[23:16]);
   adder_8b add3(a[31:24],b[31:24],c[2],c[3],sum[31:24]);
endmodule // adder_32b

   
                 
  
   
                  
                  

      
