`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:55:51 12/09/2015 
// Design Name: 
// Module Name:    chipBusController_ns_t5 
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
module chipBusController_ns_t6
  #(parameter NUM_PX = 24) (
	
	//control signals
	
	//chip signals
	input clk, //clk used for timing counter, and FSM
	input clk_px, //px clock
	input rst, //reset for FSM
	input [31:0] counter_val, //the current value of the counter
	output [4:0] px_addr, //address of pixel feeding the counter
	output [NUM_PX-1:0] stop_osc, //off signal to all pixel osc -> modify for each pixel
	output clr_counter, //clear the chip's pixel value counter
	output drdy,
	output reg [31:0] sampleOut,
	input ack_received
	
    );
	 
	 //reg [31:0] buff [NUM_PX-1:0]; //store one set of samples
	 reg loadedVal;
	 wire [NUM_PX-1:0] stopInv;
	 wire [22:0] timingCounterVal;
	 wire startupWaitFlag;
	 wire doneAccumulating;
	 wire doneAccumulatingX;
	 reg [4:0] px_addr_reg;
	 reg sentAddr;
	 parameter IDLE = 0;
	 parameter INIT = 1;
	 parameter SCAN = 2;
	 parameter COLLECT = 3;
	 parameter CLEAR = 4;
	 parameter TX_WAIT = 5;
	 parameter CHECKPX = 6;
	 parameter SCAN2 = 7;
	 parameter COLLECT2 = 8;
	 parameter CLEAR2 = 9;
	 assign px_addr = px_addr_reg;
		
	 reg [4:0] current_state, next_state;
	 reg done;
	 reg drdy_reg;
	 wire clr_cntAcc;
	 //assign start = rst;
	 reg [1:0] doneAccumulatingReg;
	 reg [4:0] startupWaitReg;
	 reg en_osc;
	 reg clr_counter_reg;
	 reg doneSendingAddr;
	 assign drdy = drdy_reg;
	 wire clk_counter;
	 /*
	 Controls
	 ---------
	 start - i2c recognizes a 'start' command
	 
	 */
	 //Chip control signals
	 // - 5 address select bits
	 // - 32 data bits
	 // - 4 byte select bits
	 // - stop (stops all osc)
	 // - clr (resets counter)
	 
	 //when drdy goes up
	 // - master sends READ cmd to chip
	 // - chip sends px * 32 bits from buff
	 // -- 1 byte + ack at a time
	 
	 //FSM
	 //idle - drdy up
	 //
	 
	 //in the scan state:
	 //- 
	 
	 //decode counter stop bit so only one is ON at a time
	 decoder5to24 uut (
		.x(px_addr), 
		.y(stopInv),
		.en(en_osc)
	 );
	 /*
	 decoder4to16 uut (
		.x(px_addr), 
		.y(stopInv),
		.en(en_osc)
	 );
	 */
	 //make stop be active high
	 assign stop_osc = ~stopInv;
	
	 //cycle through each pixel
	 /*
	 counterN #(4) counterAddress (.clr(clr_addr), .clk(px_clk), .q(px_addr));
	 assign clr_addr = (doneAccumulating | rst);
	 assign bufferIsFull = (px_addr == NUM_PX) ? 1'b1 : 1'b0;
	 assign clr_counter = (bufferIsFull | rst); //duplicate wire
	 
	 //delay the saturating bit using shift register
	 always @ (posedge clk or posedge rst) begin
		if (rst)
			bufferIsFullReg = 2'b00;
		else
			bufferIsFullReg = {bufferIsFullReg[0], bufferIsFull};
	 end
	 */
	 /*
	 always @ (negedge clk_px or posedge rst) begin
		if (rst)
			countSettledReg = 1'b0;
		else
			countSettledReg = ~countSettledReg;
	 end
	 */
	 //assign countSettled = (countSettledReg == counter_val[0]) ? 1'b0 : 1'b1;
	 //assign countSettled = ~clk_px;
	 
	 always @ (negedge clk_px) begin
		case (current_state)
			IDLE: begin
				sampleOut <= 32'd0;
				loadedVal <= 1'b0;
			end
			SCAN: begin
				loadedVal <= 1'b0;
				sampleOut <= sampleOut;
			end
			SCAN2: begin
				loadedVal <= 1'b0;
				sampleOut <= sampleOut;
			end
			COLLECT: begin
				sampleOut <= (loadedVal == 1'b1) ? sampleOut : counter_val;
				loadedVal <= 1'b1;
			end
			COLLECT2: begin
				sampleOut <= (loadedVal == 1'b1) ? sampleOut : 32'h10101010;
				loadedVal <= 1'b1;
			end
			default: begin
				sampleOut <= sampleOut;
				loadedVal <= 1'b0;
			end
		endcase	
	 end
	 
	 //counter for startup delay gen
	 always @ (posedge clk_px or posedge clr_cntAcc) begin
		if (clr_cntAcc)
			startupWaitReg = 5'b00000;
		else
			startupWaitReg = {startupWaitReg[3:0], 1'b1};
	 end
	 
	 assign startupWaitFlag = (startupWaitReg == 5'b11111) ? 1'b0 : 1'b1;
	 
	 
	 
	 //counter for timing samples
	 counterN #(23) counterAccumulation (.clr(clr_cntAcc), .clk(clk), .q(timingCounterVal));
	 
	 assign doneAccumulating = (doneAccumulatingReg == 2'b11) ? 1'b1 : 1'b0;
	 //assign doneAccumulatingX = (doneAccumulatingReg == 2'b11) ? 1'b1 : 1'b0;
	 //assign doneAccumulating = (doneAccumulatingX & countSettled);
	 assign clr_cntAcc = (rst | ~en_osc ); //clear counter on global reset or saturation
	 
	// assign clr_counter = ((doneAccumulatingReg == 2'b10)| rst) ? 1'b1 : 1'b0;//(clr_counter_reg | rst | start);
	 assign clr_counter = (startupWaitFlag | clr_counter_reg | rst );
	 //assign clr_counter = 1'b0;
	 //delay the saturating bit using shift register
	 always @ (posedge clk or posedge rst) begin
		if (rst)
			doneAccumulatingReg = 2'b00;
		else
			doneAccumulatingReg = {doneAccumulatingReg[0], timingCounterVal[22]};
	 end
	 
	 
	 
	 //generic FSM state transition
	 always @ (posedge clk or posedge rst) begin
		if (rst)
			current_state = IDLE;
		else
			current_state = next_state;
	 end
	 
	 //next state transitions
	 always @ (*) begin
		case (current_state)
			IDLE: begin //start automatically
				next_state = INIT;
			end
			INIT: begin //init regs
				next_state = SCAN;
			end
			SCAN: begin //wait for data to accumulate
				if (doneAccumulating)
					next_state = COLLECT;
				else
					next_state = SCAN;
			end
			COLLECT: begin //tell i2c that data is ready
				next_state = CLEAR;
			end
			CLEAR: begin
				next_state = TX_WAIT;
			end
			TX_WAIT: begin
				if (ack_received)
					next_state = CHECKPX;
				else
					next_state = TX_WAIT;
			end
			CHECKPX: begin
				if (px_addr_reg[4:0] == 5'd0 && !sentAddr)
					next_state = SCAN2;
				else
					next_state = SCAN;
			end
			SCAN2: begin
				if (doneAccumulating)
					next_state = COLLECT2;
				else
					next_state = SCAN2;
				//next_state = COLLECT;
				//next_state = SCAN;
				/*
				if (doneWaiting) //delay to allow i2c cycle to end
					next_state = COLLECT;
				else
					next_state = CHECKPX_TX;*/
			end
			COLLECT2: begin
				next_state = CLEAR2;
			end
			CLEAR2: begin
				next_state = TX_WAIT;
			end
			
			default: begin
				next_state = IDLE;
			end
		endcase
	 end
	 
	 always @ (posedge clk) begin
		case (current_state)
			IDLE: begin
				
			end
			INIT: begin
				//reset everything
				clr_counter_reg <= 0;
				px_addr_reg <= 0;
				//sampleOut <= 0;
				en_osc <= 0;
				drdy_reg <= 1'b1;
				sentAddr <= 1'b0;
			end
			SCAN: begin
				drdy_reg <= 1'b1;
				en_osc <= 1'b1;
				clr_counter_reg <= 1'b0;
				//pxflag <= 1'b0;
			end
			COLLECT: begin
				//clr_counter_reg <= 1;
				//$display("%d SCAN END: %t",px_addr_reg,$time);
				//$display("%d - %d - %d - %t",px_addr_reg,clr_counter,doneAccumulatingReg,$time); //$display("start <= %b :%t : %b", start, $time, timingCounterVal);
				//sampleOut <= counter_val;
				//px_addr_reg <= px_addr_reg + 5'd1;
				sentAddr <= 1'b0;
				
				

				drdy_reg <= 1'b0;
				//px_addr_reg <= px_addr_reg + 1;
				
			end
			CLEAR: begin //extra cycle to allow latching
				if (px_addr_reg == 5'd23)
					px_addr_reg <= 5'd0;
				else
					px_addr_reg <= px_addr_reg + 5'd1;
				en_osc <= 1'b0;
				
			end
			TX_WAIT: begin
				en_osc <= 1'b0;
				clr_counter_reg <= 1'b1;

			end
			CHECKPX: begin
				//do nothing
			end
			SCAN2: begin
				drdy_reg <= 1'b1;
				en_osc <= 1'b1;
				clr_counter_reg <= 1'b0;
				/*
				//sampleOut <= 32'h10101010;
				if (!doneSendingAddr)
					pxflag <= 1'b1;
				else
					pxflag <= 1'b0;*/
			end
			COLLECT2: begin
				//sampleOut <= 32'h10101010;
				sentAddr <= 1'b1;
				drdy_reg <= 1'b0;
				/*
				if (!doneSendingAddr)
					pxflag <= 1'b1;
				else
					pxflag <= 1'b0;*/
			end
			CLEAR2: begin //extra cycle to allow latching
				en_osc <= 1'b0;
				
			end
			default: begin

			end
		endcase
	 end
	 
endmodule