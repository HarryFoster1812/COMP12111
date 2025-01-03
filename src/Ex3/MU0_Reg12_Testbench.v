// COMP12111 Exercise 3 - MU0_Reg12 Testbench
// Version 2024. P W Nutter
//
// Testbench for the 12-bit Register
// DUT is instantiated for you.
// Need to complete the test stimulus.
//
// Comments:
// Harry Foster, Date(07/11/2024)
// Added testing for the Reg12 
//

// Do not touch the following lines as they required for simulation 
`timescale  1ns / 100ps
`default_nettype none

module MU0_Reg12_Testbench();

//  Internal signals have been defined for you
//  and must be used for this excercise 
//  DO NOT alter the names of these signals 

reg   [11:0] D;
reg          Clk;
reg          Reset;
reg          En; 
wire  [11:0] Q;


// The design has been instantiated for you below:

MU0_Reg12 top(.D(D), .Clk(Clk), .Reset(Reset), .En(En), .Q(Q) );


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


// test writing to thte register
D = 12'd10;
En = 12'd1;
#1000
// Expected output: 10

// test disabling enable
En = 12'd0;
D = 12'd5;
# 1000
// Expected output: 10

// test reset and enable high at the same time
Reset = 12'd1;
En = 12'd1;
#100
// Expected output: 0

// test writing when reset goes low
Reset = 12'd0;
#100
// Expected output: 5


// -------------------------------------------------------
// Please make sure your stimulus is above this line

#100 $stop;
end


endmodule

`default_nettype wire
