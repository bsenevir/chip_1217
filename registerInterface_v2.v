//////////////////////////////////////////////////////////////////////
////                                                              ////
//// registerInterface.v                                          ////
////                                                              ////
//// This file is part of the i2cSlave opencores effort.
//// <http://www.opencores.org/cores//>                           ////
////                                                              ////
//// Module Description:                                          ////
//// You will need to modify this file to implement your 
//// interface.
//// Add your control and status bytes/bits to module inputs and outputs,
//// and also to the I2C read and write process blocks  
////                                                              ////
//// To Do:                                                       ////
//// 
////                                                              ////
//// Author(s):                                                   ////
//// - Steve Fielding, sfielding@base2designs.com                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2008 Steve Fielding and OPENCORES.ORG          ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE. See the GNU Lesser General Public License for more  ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from <http://www.opencores.org/lgpl.shtml>                   ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
`include "i2cSlave_define.v"


module registerInterface_v2 (
  clk,
  addr,
  dataOut,
  myReg0,
  myReg1,
  myReg2,
  myReg3
);
input clk;
input [1:0] addr;
output reg [7:0] dataOut;
input [7:0] myReg0;
input [7:0] myReg1;
input [7:0] myReg2;
input [7:0] myReg3;



/*
reg [7:0] myReg0 = 8'h01;
reg [7:0] myReg1 = 8'h02;
reg [7:0] myReg2 = 8'h03;
reg [7:0] myReg3 = 8'h04;
*/
// --- I2C Read
always @(posedge clk) begin
  case (addr)
    2'd0: dataOut <= myReg0;  
    2'd1: dataOut <= myReg1;  
    2'd2: dataOut <= myReg2;  
    2'd3: dataOut <= myReg3;   
    default: dataOut <= 8'h00;
  endcase
end

endmodule


 
