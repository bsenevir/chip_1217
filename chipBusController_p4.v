`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:34:26 11/23/2017 
// Design Name: 
// Module Name:    chipBusController_p4 
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
module chipBusController_p4
  #(parameter NUM_PX = 24) (
	
	//control signals
	
	//chip signals
	input clk, //clk used for timing counter, and FSM
	input rst, //reset for FSM
	input [31:0] counter_val1, //the current value of the counter
	input [31:0] counter_val2, //the current value of the counter
	input [31:0] counter_val3, //the current value of the counter
	input [31:0] counter_val4, //the current value of the counter
	input [31:0] counter_val5, //the current value of the counter
	output [1:0] px_addr, //address of pixel feeding the counter
	output [4:0] stop_osc, //off signal to all pixel osc -> modify for each pixel
	output clr_counter, //clear the chip's pixel value counter
	output drdy,
	output reg [31:0] sampleOut,
	input ack_received,
	output en_osc_out
	
    );
	 
	 wire [31:0] counter_val [0:4];
	 assign counter_val[0] = counter_val1;
	 assign counter_val[1] = counter_val2;
	 assign counter_val[2] = counter_val3;
	 assign counter_val[3] = counter_val4;
	 assign counter_val[4] = counter_val5;
	 
	 //reg [31:0] buff [NUM_PX-1:0]; //store one set of samples
	 reg loadedVal;
	 wire [4:0] stopInv;
	 wire [22:0] timingCounterVal;
	 wire startupWaitFlag;
	 wire doneAccumulating;
	 wire doneAccumulatingX;
	 reg [1:0] px_addr_reg;
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
	 parameter LOADCOUNT = 10;
	 parameter INCR_PX = 11;
	 parameter CYCLE_CHECK = 12;
	 
	 assign px_addr = px_addr_reg;
		
	 reg [4:0] current_state, next_state;
	 reg drdy_reg;
	 wire clr_cntAcc;
	 //assign start = rst;
	 reg [1:0] doneAccumulatingReg;
	 reg [1:0] doneAccumulatingRegAddr;
	 reg [4:0] startupWaitReg;
	 reg en_osc;
	 reg clr_counter_reg;
	 assign drdy = drdy_reg;
	 reg [2:0] samp_track;
	 
	 reg ack_received2;
	 wire ack_received_fix;
	 
	 assign ack_received_fix = (ack_received & ~ack_received2);
	 assign en_osc_out = en_osc;
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
	 decoder3to5 uut (
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
	 
	 
	 
	 //counter for startup delay gen
	 always @ (posedge clk or posedge clr_cntAcc) begin
		if (clr_cntAcc)
			startupWaitReg = 5'b00000;
		else
			startupWaitReg = {startupWaitReg[3:0], 1'b1};
	 end
	 
	 assign startupWaitFlag = (startupWaitReg == 5'b11111 || startupWaitReg == 5'b00000) ? 1'b0 : 1'b1;
	 
	 
	 
	 //counter for timing samples
	 counterN #(23) counterAccumulation (.clr(clr_cntAcc), .clk(clk), .q(timingCounterVal));
	 
	 assign doneAccumulating = (doneAccumulatingReg == 2'b11) ? 1'b1 : 1'b0;
	 assign doneAccumulatingX = (doneAccumulatingRegAddr == 2'b11) ? 1'b1 : 1'b0;
	 //assign doneAccumulatingX = (doneAccumulatingReg == 2'b11) ? 1'b1 : 1'b0;
	 //assign doneAccumulating = (doneAccumulatingX & countSettled);
	 assign clr_cntAcc = (rst | ~en_osc ); //clear counter on global reset or saturation
	 
	// assign clr_counter = ((doneAccumulatingReg == 2'b10)| rst) ? 1'b1 : 1'b0;//(clr_counter_reg | rst | start);
	 //assign clr_counter = (clr_counter_reg | rst );
	 assign clr_counter = (startupWaitFlag | clr_counter_reg | rst );
	 //assign clr_counter = 1'b0;
	 //delay the saturating bit using shift register
	 always @ (posedge clk or posedge rst) begin
		if (rst) begin
			doneAccumulatingReg = 2'b00;
			doneAccumulatingRegAddr = 2'b00;
			end
		else begin
			//fix to bit [22]
			doneAccumulatingReg = {doneAccumulatingReg[0], timingCounterVal[22]};
			doneAccumulatingRegAddr = {doneAccumulatingRegAddr[0], timingCounterVal[6]};
			end
	 end
	 
	 always @ (posedge clk or posedge rst) begin
		if (rst)
			ack_received2 <= 0;
		else
			ack_received2 <= ack_received;
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
				if (ack_received_fix)
					next_state = CYCLE_CHECK; //LOADCOUNT
				else
					next_state = TX_WAIT;
			end
			CYCLE_CHECK: begin
				if (sentAddr)
					next_state = SCAN;
				else
					next_state = LOADCOUNT;
			end
			CHECKPX: begin
				if (px_addr_reg[1:0] == 2'd0 && !sentAddr)
					next_state = SCAN2;
				else
					next_state = SCAN;
			end
			SCAN2: begin
				if (doneAccumulatingX)
					next_state = COLLECT2;
				else
					next_state = SCAN2;
			end
			COLLECT2: begin
				next_state = CLEAR2;
			end
			CLEAR2: begin
				next_state = TX_WAIT;
			end
			LOADCOUNT: begin
			if (samp_track >= 3'd5)
				next_state = INCR_PX;
			else
				next_state = COLLECT;
			end
			
			INCR_PX: begin
				next_state = CHECKPX;
			end
			
			default: begin
				next_state = IDLE;
			end
		endcase
	 end
	 
	 always @ (posedge clk) begin
		case (current_state)
			IDLE: begin
				sampleOut <= 32'd0;
				loadedVal <= 1'b0;
				samp_track <= 3'd0;
			end
			INIT: begin
				//reset everything
				clr_counter_reg <= 0;
				px_addr_reg <= 0;
				en_osc <= 0;
				drdy_reg <= 1'b1;
				sentAddr <= 1'b0;
				samp_track <= 3'd0;
			end
			SCAN: begin
				drdy_reg <= 1'b1;
				en_osc <= 1'b1;
				clr_counter_reg <= 1'b0;
				sampleOut <= 32'd0;
				loadedVal <= 1'b0;
			end
			COLLECT: begin
				sentAddr <= 1'b0;
				
				en_osc <= 1'b0;
			end
			CLEAR: begin //extra cycle to allow latching
				sampleOut <= (loadedVal == 1'b1) ? sampleOut : counter_val[samp_track];
				loadedVal <= 1'b1;
				drdy_reg <= 1'b0;
			end
			TX_WAIT: begin
				en_osc <= 1'b0;
			end
			CYCLE_CHECK: begin
				//clr_counter_reg <= 1;
			end
				
			CHECKPX: begin
				clr_counter_reg <= 1'b1;
			end
			SCAN2: begin
				drdy_reg <= 1'b1;
				en_osc <= 1'b1;
				clr_counter_reg <= 1'b0;
				sampleOut <= 32'd0;
				loadedVal <= 1'b0;
			end
			COLLECT2: begin
				en_osc <= 1'b0;
				sentAddr <= 1'b1;
			end
			CLEAR2: begin //extra cycle to allow latching
				sampleOut <= (loadedVal == 1'b1) ? sampleOut : 32'h10101010;
				loadedVal <= 1'b1;
				drdy_reg <= 1'b0;
			end
			LOADCOUNT: begin
				drdy_reg <= 1'b1;
				loadedVal <= 1'b0;
				samp_track <= samp_track + 3'd1;
			end
			
			INCR_PX: begin
				px_addr_reg <= (px_addr_reg < 2'd3) ? px_addr_reg + 2'd1 : 2'd0;
				samp_track <= 3'd0;
			end
			
			default: begin
				sampleOut <= sampleOut;
				loadedVal <= 1'b0;
			end
		endcase
	 end
	 
endmodule