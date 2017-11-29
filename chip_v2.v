`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:24:53 11/29/2017 
// Design Name: 
// Module Name:    chip_v2 
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
module chip_v2(
	input clk, //default clock
	input rst,
	inout sda,
	input scl,
	input testSig,
	output drdy
    );
	
	wire [4:0] stop_osc;
	wire [19:0] clk_px;
	
	assign clk_px[16] = testSig;
	
	i2cSlaveTop_v8 theDigitalBlock (
		.clk(clk),
		.clk_px(),
		.rst(rst),
		.sda(sda),
		.scl(scl),
		.px_addr(),
		.stop_osc(stop_osc),
		.drdy(drdy)
	);
	
	analogPxArray theAnalogBlock (
		.clk_px(clk_px[15:0]),
		.stop_osc(stop_osc)
    );


endmodule
