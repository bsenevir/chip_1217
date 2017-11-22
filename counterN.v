`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:35:09 03/05/2013 
// Design Name: 
// Module Name:    counterN 
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
module counterN
	#(parameter N = 4) (
		input wire clr ,
		input wire clk ,
		output reg [N-1:0] q
	);
	
	// N-bit counter
	always @(posedge clk or posedge clr)
	begin
		if (clr == 1)
			q <= 0;
		else
			q <= q + 1;
	end
endmodule

