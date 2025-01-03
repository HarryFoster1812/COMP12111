// COMP12111 Exercise 3 - MU0_Reg12 
// Version 2024. P W Nutter
// 
// 12-bit Register implementation
//
// Implement using behavioural Verilog
//
// Comments:
// Harry Foster, Date(07/11/2024)
// This module describes how a the 12 bit register works
// uses sequential logic as it is synchronos so blocking stements are used
// 
// Date(08/11/2024)
// Restructured the module by removing two case statements and doing as before in Ex2
//
// Date(15/11/2024)
// Changed any assignments of constants to nb' format following the feedback of Ex2
// Added more comments
// changed blocking to non blocking



// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps

// for simulation purposes, do not delete
`default_nettype none

// module definition

module MU0_Reg12 (
input  wire        Clk, 
input  wire        Reset,     
input  wire        En, 
input  wire [11:0] D, 
output reg  [11:0] Q
);

// behavioural code - clock driven

// on the rising clock edge or when reset is enabled
always @ (posedge Clk, posedge Reset)
begin
	if(Reset) // check is reset is high
	begin
		Q <= 12'd0;
	end

	else if (En) // reset is not high so check if Enable is
	begin
		Q <= D;
	end

end

endmodule 

// for simulation purposes, do not delete
`default_nettype wire
