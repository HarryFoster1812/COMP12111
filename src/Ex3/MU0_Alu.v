// COMP12111 Exercise 3 - MU0_Alu 
// Version 2024. P W Nutter
//
// MU0 ALU design 
//
// Comments:
// Harry Foster, Date(07/11/2024)
// This module describes how the MU0 Alu works
// It uses combinatorial logic so blocking statements are used
// 
// Date(15/11/2024)
// Changed any assignments of constants to nb' format following the feedback of Ex2
// Added more comments



// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps
`default_nettype none

// module header

module MU0_Alu (
               input  wire [15:0]  X, 
               input  wire [15:0]  Y, 
               input  wire [1:0]   M, 
               output reg  [15:0]  Q
	       );

// behavioural description for the ALU
	always @ (*)
	begin
		case(M)
			2'b00 	: Q = Y;
			2'b01 	: Q = X+Y;
			2'b10 	: Q = X+16'd1;
			2'b11 	: Q = X+(~Y+16'd1); // X - Y
			default : Q = 16'bx; // we need to handle the case whn the input is 2'bx
		endcase
	end

endmodule 

// for simulation purposes, do not delete
`default_nettype wire
