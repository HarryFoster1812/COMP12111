// COMP12111 Exercise 3 - MU0_Mux12 Testbench
// Version 2024. P W Nutter
//
// Testbench for the 2-to-1 12-bit MUX
// DUT is instantiated for you.
// Need to complete the test stimulus.
//
// Comments:
//
//
//

// Do not touch the following lines as they required for simulation 
`timescale  1ns / 100ps
`default_nettype none

module MU0_Mux12_Testbench();

//  Internal signals have been defined for you
//  and must be used for this excercise 
//  DO NOT alter the names of these signals 

reg   [11:0] A, B;
reg          S; 
wire  [11:0] Q; 


// The design has been instantiated for you below:

MU0_Mux12 top(.A(A), .B(B), .S(S), .Q(Q) );


/* Comment block

#VALUE      creates a delay of VALUE ps
a=VALUE;    sets the value of input 'a' to VALUE
$stop;      tells the simulator to stop

*/

initial
begin
// Enter you stimulus below this line
// -------------------------------------------------------

// check s high
A = 12'd1;
B = 12'd2;
S = 12'd1;
# 100
// should output 2

// check s low
S = 12'd0;
#100
// Should output 1

// check that changing the inputs will also change the output when s low
A = 12'd3; 
// Should output 3

// check that changing the inputs will also change the output when s high
B = 12'd0;
#100
S = 12'd1;
//Should output 0
#100

// -------------------------------------------------------
// Please make sure your stimulus is above this line

#100 $stop;
end


endmodule

`default_nettype wire
