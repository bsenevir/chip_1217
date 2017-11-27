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
module i2cSlaveTop_v8(
	input clk, //default clock
	input [19:0] clk_px,
	input rst,
	inout sda,
	input scl,
	output [1:0] px_addr, //address of pixel feeding the counter
	output [4:0] stop_osc, //off signal to all pixel osc -> modify for each pixel
	output drdy
);
	
	wire ack_received;
	wire [31:0] sampleOut;
	wire [31:0] counter_val [0:4];
	wire [4:0] clk_px_sel; //selected pixels for each counter
	wire en_osc_out;
	
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

	chipBusController_p4 logicUnit (
		.clk(clk),
		.rst(rst), 
		.counter_val1(counter_val[0]),
		.counter_val2(counter_val[1]),
		.counter_val3(counter_val[2]),
		.counter_val4(counter_val[3]),
		.counter_val5(counter_val[4]),
		.px_addr(px_addr), 
		.stop_osc(stop_osc), 
		.clr_counter(clr_counter), 
		.drdy(drdy),
		.sampleOut(sampleOut),
		.ack_received(ack_received),
		.en_osc_out(en_osc_out)
	);
	
	
	mux41_en m1 (.select(px_addr), .d(clk_px[3:0]), .en(en_osc_out), .q(clk_px_sel[0]));
	mux41_en m2 (.select(px_addr), .d(clk_px[7:4]), .en(en_osc_out), .q(clk_px_sel[1]));
	mux41_en m3 (.select(px_addr), .d(clk_px[11:8]), .en(en_osc_out), .q(clk_px_sel[2]));
	mux41_en m4 (.select(px_addr), .d(clk_px[15:12]), .en(en_osc_out), .q(clk_px_sel[3]));
	mux41_en m5 (.select(px_addr), .d(clk_px[19:16]), .en(en_osc_out), .q(clk_px_sel[4]));
	
	//////////////////////////
	//Implement counter32 inside block
	//////////////////////////
	//counter running of microcontroller clk
	counterN #(32) counterChip1 (.clr(clr_counter), .clk(clk_px_sel[0]), .q(counter_val[0]));
	counterN #(32) counterChip2 (.clr(clr_counter), .clk(clk_px_sel[1]), .q(counter_val[1]));
	counterN #(32) counterChip3 (.clr(clr_counter), .clk(clk_px_sel[2]), .q(counter_val[2]));
	counterN #(32) counterChip4 (.clr(clr_counter), .clk(clk_px_sel[3]), .q(counter_val[3]));
	counterN #(32) counterChip5 (.clr(clr_counter), .clk(clk_px_sel[4]), .q(counter_val[4]));
	
	
	

endmodule


 
