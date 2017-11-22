`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:19:47 12/06/2015 
// Design Name: 
// Module Name:    i2cSlaveTop_v6 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module i2cSlaveTop_v8_s(
	input clk, //default clock
	input clk_px,
	input rst,
	inout sda,
	input scl,
	output [4:0] px_addr, //address of pixel feeding the counter
	output [23:0] stop_osc, //off signal to all pixel osc -> modify for each pixel
	output drdy
);
	
	wire ack_received;
	wire [31:0] sampleOut;
	wire [31:0] counter_val;

	i2cSlave_v2 u_i2cSlave(
	  .clk(clk),
	  .rst(rst),
	  .sda(sda),
	  .scl(scl),
	  .myReg3(sampleOut[7:0]),
	  .myReg2(sampleOut[15:8]),
	  .myReg1(sampleOut[23:16]),
	  .myReg0(sampleOut[31:24]),
	  .ack_received(ack_received),
	  .statusLED()
	);

	chipBusController_ns_t6 logicUnit (
		.clk(clk),
		.clk_px(clk_px),
		.rst(rst), 
		.counter_val(counter_val),
		.px_addr(px_addr), 
		.stop_osc(stop_osc), 
		.clr_counter(clr_counter), 
		.drdy(drdy),
		.sampleOut(sampleOut),
		.ack_received(ack_received)
	);
	
	//////////////////////////
	//Implement counter32 inside block
	//////////////////////////
	
	//counter running of microcontroller clk
	counterN #(32) counterChip (.clr(clr_counter), .clk(clk_px), .q(counter_val));
	
	
	

endmodule


 
