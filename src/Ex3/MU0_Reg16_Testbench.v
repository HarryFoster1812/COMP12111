// COMP12111 Exercise 3 - MU0_Reg16 Testbench
// Version 2024. P W Nutter
//
// Testbench for the 16-bit Register
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

module MU0_Reg16_Testbench();

//  Internal signals have been defined for you
//  and must be used for this excercise 
//  DO NOT alter the names of these signals 

reg   [15:0] D;
reg          Clk;
reg          Reset;
reg          En; 
wire  [15:0] Q;


// The design has been instantiated for you below:

MU0_Reg16 top(.D(D), .Clk(Clk), .Reset(Reset), .En(En), .Q(Q) );


/* Comment block

#VALUE      creates a delay of VALUE ps
a=VALUE;    sets the value of input 'a' to VALUE
$stop;      tells the simulator to stop

*/

// Clk setup

initial Clk <= 0;

always
	#100
	Clk = ~Clk;


initial
begin
// Enter you stimulus below this line
// -------------------------------------------------------

D = 10;
En = 1;
#1000
// Expected output: 10
En = 0;
D = 5;
# 1000
// Expected output: 10
Reset = 1;
#100
// Expected output: 0
Reset = 0;
En = 1;
#100
// Expected output: 5
D = 6;
En = 0;
#100



// -------------------------------------------------------
// Please make sure your stimulus is above this line

#100 $stop;
end


endmodule

`default_nettype wire
