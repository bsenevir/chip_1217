`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:10 11/24/2017 
// Design Name: 
// Module Name:    decoder2to4 
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
module decoder3to5(
	input [1:0] x,
	output [4:0] y,
	input en
   );
	 assign y = (en) ? (5'd1 << x) : 5'd0;

endmodule