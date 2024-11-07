// COMP12111 Exercise 3 - MU0_Alu 
// Version 2024. P W Nutter
//
// MU0 ALU design 
//
// Comments:
//
//
//

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
			2'b00 : assign Q = Y;
			2'b01 : assign Q = X+Y;
			2'b10 : assign Q = X+1;
			2'b11 : assign Q = X+(~Y+1);
			default : assign Q = 'x;
		endcase
	end

endmodule 

// for simulation purposes, do not delete
`default_nettype wire
