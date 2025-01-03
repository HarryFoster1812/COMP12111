// COMP12111 Exercise 2 - Sequential Design Testbench
//
// Version 2024. P W Nutter
//
// This is the Verilog module for the traffic light testbench
// Tests for the traffic light should be added to this file
//
// Make sure you document your code and marks may be awarded/lost for the 
// quality of the comments given.
//
// Add your comments:
//
//
//

`timescale  1ns / 100ps
`default_nettype none


module Traffic_Light_Testbench;
 
//  Internal signals have been defined for you
//  and must be used for this excercise 
//  DO NOT alter names, and ensure that your signals
//  are wired up correctly to your design under test 

wire [5:0]  lightseq; 
reg   clock;
reg   reset;
reg   D1;
reg   D2;

// The design has been instantiated for you below:

Traffic_Light top(.clock(clock), .reset(reset), .D1(D1), .D2(D2), .lightseq(lightseq));


//
// Testing of a sequential design requires you to implement
// a clock - see the advice in Blackboard on how to do this
//

/*

#VALUE      creates a delay of VALUE ns
a=VALUE;    sets the value of input 'a' to VALUE
$stop;      tells the simulator to stop

*/

// Implement your clock here
// -----------------------------------------------------

initial clock = 1'b0;

always
	begin
	#50
	clock = ~clock;
	end

// -----------------------------------------------------


initial
begin

// Set input signals here, using delays where appropriate
// -----------------------------------------------------
	D1 = 0;
	D2 = 0;
	reset = 1;
	#100
	reset=0;
	#100
	D1 = ~D1;
	#1050
	D1 = ~D1;
	#50
	D2 = ~D2;
	#1000
#100 $stop;
end

endmodule

`default_nettype wire
