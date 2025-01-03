// COMP12111 Exercise 3 - MU0_Datapath 
// Version 2024. P W Nutter
//
// MU0 datapath design - structural Verilog
// Design is incomplete - functional components of the
// MU0 datapath need instantiation.
// Use the names used in the lab instructions.
//
// Comments:
// Harry Foster, Date(07/11/2024)
// this module instantiates all of the modules requred to complete the datapath design given in the lab instructions
// 
// Date(15/11/2024)
// Changed any assignments of constants to nb' format following the feedback of Ex2
// Added more comments

// Do not touch the following line it is required for simulation 
`timescale 1ns/100ps

// for simulation purposes, do not delete
`default_nettype none

module MU0_Datapath(
input  wire        Clk,
input  wire        Reset,
input  wire [15:0] Din,
input  wire        X_sel,
input  wire        Y_sel,
input  wire        Addr_sel,
input  wire        PC_En,
input  wire        IR_En,
input  wire        Acc_En,
input  wire [1:0]  M,
output wire [3:0]  F,			// top 4 bits of the instruction
output wire [11:0] Address,
output wire [15:0] Dout,
output wire        N,
output wire        Z,
output wire [11:0] PC,
output wire [15:0] Acc);


// Define internal signals using names from the datapath schematic
wire [15:0] X;
wire [15:0] IR;
wire [15:0] Y;
wire [15:0] ALU; 

// Instantiate Datapath components

//MU0 registers

//12 bit reg

MU0_Reg12 PCReg(.En(PC_En), .Reset(Reset), .Clk(Clk), .D(ALU[11:0]), .Q(PC));

// 16 bit reg

MU0_Reg16 IRReg(.En(IR_En), .Reset(Reset), .Clk(Clk), .D(Din[15:0]), .Q(IR));
MU0_Reg16 ACCReg(.En(Acc_En), .Reset(Reset), .Clk(Clk), .D(ALU[15:0]), .Q(Acc));

// MU0 multiplexors

// 12 bit mux

MU0_Mux12 AddrMux(.A(PC[11:0]), .B(IR[11:0]), .S(Addr_sel), .Q(Address[11:0]));

// 16 bit mux
MU0_Mux16 XMux(.A(Acc[15:0]), .B({4'b0000, PC[11:0]}), .S(X_sel), .Q(X));
MU0_Mux16 YMux(.A(Din[15:0]), .B(IR[15:0]), .S(Y_sel), .Q(Y));

// MU0 ALU

MU0_Alu MU0_ALU(.X(X), .Y(Y), .M(M), .Q(ALU));

// MU0 Flag generation

MU0_Flags FLAGS(.Acc(Acc), .N(N), .Z(Z));


// The following connects X and Dout together, there's no need for you to do so
// use X when defining your datapath structure
assign Dout = X;
// Buffer added F is op 4 bits of the instruction
assign F = IR[15:12];

endmodule 

// for simulation purposes, do not delete
`default_nettype wire
