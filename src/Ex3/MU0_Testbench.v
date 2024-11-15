// COMP12111 Exercise 3 - MU0_Testbench
// Version 2024. P W Nutter
//
// Testbench for the MU0 processor
// DUT and Memory are instantiated for you.
// Need to complete the test stimulus.
//
// Comments:
//
//
//

// Do not touch the following lines as they required for simulation 
`timescale 1ns/100ps 
`default_nettype none

module MU0_Testbench();

// Define any internal connections

reg Clk;
reg Reset;
wire [15:0] Din;
wire Wr;
wire [11:0] Address;
wire [15:0] Dout;
wire Halted;




// mu0 as dut (device under test) and mu0_memory have been instantiated
// for you


MU0 MU01 (
         .Clk(Clk),  .Reset(Reset), .Din(Din),  .Wr(Wr), .Addr(Address), 
         .Dout(Dout), .Halted(Halted)
         );

MU0_Memory MEM1 ( 
                .keypad(),
                .Simple_buttons(),
                .buttons_AtoH(),
		        .s7_leds(),
                .traffic_lights(),
                .breakpoint_mem_adr(),
                .buzzer_pulses(),
	         	.digit0(),
                .digit1(),
	            .digit2(),
		        .digit3(),
                .digit4(),
	            .digit5(),
                .WEnAckie_bp(1'b0),
		        .bp_mem_detected(),
                .bp_mem_data_ackie_read(),
                .bp_mem_data_ackie_write(),
	            .Clk(Clk),
                .write_data1(),
	            .write_data0(Dout),
                .address1(),
	            .address0(Address),
                .WEn1(1'b0),
	            .WEn0(Wr),
		        .read_data1(),
                .read_data0(Din)
		);


// set up the clock

initial Clk <= 1'b0;
always
	#50
	Clk = ~Clk; 

// Perform a reset action of MU0
initial
begin

Reset = 1'b0;
#200
Reset = 1'b1;
#1000
Reset = 1'b0;
#10000
#100 $stop(); // stop the simulation - could tie this to the Halted signal going high
end
 

endmodule 

`default_nettype wire
