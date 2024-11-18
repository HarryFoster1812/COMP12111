// COMP12111 Exercise 3 - MU0_Mux16 
// Version 2024. P W Nutter
// 
// 2-to-1 16-bit MUX implementation
//
// Implement using behavioural Verilog
//
// Comments:
// Harry Foster, Date(07/11/2024)
// This module describes how a the 16 bit mux works
// uses combinatorial logic so blocking stements are used
// if s = 1 then output B else output A


// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps

// for simulation purposes, do not delete
`default_nettype none

// module definition

module MU0_Mux16 (
input  wire  [15:0] A, 
input  wire  [15:0] B, 
input  wire         S, 
output reg  [15:0]  Q
);


// Combinatorial logic for 2to1 multiplexor
// S is select, A channel0, B channel1

always @ (*)
begin
	if (S)
	begin
		Q = B;
	end

	else
	begin
		Q = A;
	end
end

endmodule 

// for simulation purposes, do not delete
`default_nettype wire
