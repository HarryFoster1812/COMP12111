// Verilog HDL for "COMP12111", "trafficlight" "functional"
//
// COMP12111 - Exercise 2 – Sequential Circuits
//
// Version 2024. P W Nutter
//
// This is the Verilog module for the traffic light junction
//
// The aim of this exercise is complete the finite state machine using the
// state transition diagram given in the laboratory notes. 
//
// DO NOT change the interface to this design or it may not be marked completely
// when submitted.
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

module Traffic_Light ( 	output reg [5:0] lightseq,	//the 6-bit light sequence
		         		input  wire      clock,		//clock that drives the fsm
		         		input  wire      reset,		//reset signal 
		         		input  wire      D1, D2);	//inputs from cars

// declare internal variables here
	reg[3:0] current_state;
	reg[3:0] next_state;	
	`define R__R 6'b100100; // lights in state 0 and 8
	`define RA_R 6'b110100; // state 1
	`define G__R 6'b001100; // state 2 - 6
	`define A__R 6'b010100; // state 7
	`define R_RA 6'b100110; // state 9
	`define R__G 6'b100001; // state 10-14
	`define R__A 6'b100010; // state 2
// implement your next state combinatorial logic block here


	always @ (*)
	begin
		case(current_state)
			0:next_state<=1;
			1:next_state<=2;
			2:next_state<=3;
			3:next_state<=4;

			4:
				if (D2==1) begin
					next_state <= 7;
				end
				else begin
					next_state <= 5;
				end
			5:
				if (D2==1) begin
					next_state <= 7;
				end
				else begin
					next_state <= 6;
				end

			6:next_state<=7;
			7:next_state<=8;
			8:next_state<=9;
			9:next_state<=10;
			10:next_state<=11;
			11:next_state<=12;

			12:
				if (D1==1) begin
					next_state <= 15;
				end
				else begin
					next_state <= 13;
				end
			13:
				if (D1==1) begin
					next_state <= 15;
				end
				else begin
					next_state <= 14;
				end


			14:next_state<=15;
			15:next_state<=0;
		endcase
	end

	
// implement your current state assignment, register, here


always @ (posedge clock, posedge reset) 
	begin	
		if (reset==1) begin
			current_state <= 0;
		end
		else
		begin
			current_state <= next_state;
		end
	end

// implement your output logic here
always @(*)
	begin
	case (current_state)
		0:lightseq=`R__R
		1:lightseq=`RA_R
		2:lightseq=`G__R
		3:lightseq=`G__R
		4:lightseq=`G__R
		5:lightseq=`G__R
		6:lightseq=`G__R
		7:lightseq=`A__R
		8:lightseq=`R__R
		9:lightseq=`R_RA
		10:lightseq=`R__G
		11:lightseq=`R__G
		12:lightseq=`R__G
		13:lightseq=`R__G
		14:lightseq=`R__G
		15:lightseq=`R__A
	endcase
	end
endmodule

`default_nettype wire
