`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:26:47 12/20/2015 
// Design Name: 
// Module Name:    decoder5to24 
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
module decoder5to24(
	input [4:0] x,
	output [23:0] y,
	input en
   );
	 assign y = (en) ? (24'd1 << x) : 24'd0;

endmodule
