// COMP12111 Exercise 3 - MU0_Reg16 
// Version 2024. P W Nutter
// 
// 16-bit Register implementation
//
// Implement using behavioural Verilog
//
// Comments:
//
//
//

// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps

// for simulation purposes, do not delete
`default_nettype none

// module definition

module MU0_Reg16 (
input  wire        Clk, 
input  wire        Reset,     
input  wire        En, 
input  wire [15:0] D, 
output reg  [15:0] Q
 );

// behavioural code - clock driven

// on the rising clock edge or when reset is enabled
always @ (posedge Clk, posedge Reset)
begin
	if(Reset) // check is reset is high
	begin
		Q = 0;
	end

	else // reset is not high so check if Enable is
	begin
		case(En)
			0 : Q = Q;
			1 : Q = D; // if En is high then set output to input 
			default : Q = 1'bx; // else use the previous output
		endcase
	end

end

endmodule 

// for simulation purposes, do not delete
`default_nettype wire
