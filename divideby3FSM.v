module divideby3FSM(input logic clk,
                    input logic reset,
                    ouput logic y);
   typedef enum                 logic [1:0] {S0,S1,S2} statetype;
   statetype [1:0] state,nextstate;
   
   //state register
   always_ff @(posedge clk,posedge reset)
     if(reset) state <= S0;
     else state <= nextstate;
   //next state logic
   always_comb
     case(state)
       S0: nextstate <= S1;
       S1: nextstate <= S2;
       s2: nextstate <= S0;
       default: nextstate <= S0;
     endcase // case (state)
   //output logic
   assign y = (state == S0);
endmodule // divideby3FSM

     
    
   
  
