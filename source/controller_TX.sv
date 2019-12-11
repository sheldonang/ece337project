module controller_TX
(
input wire clk,
input wire n_rst,
input wire [1:0] TX_packet, 
input wire rollover_flag1, 
input wire rollover_flag2,
input wire rollover_flag3, 

output wire crc_done, 
output wire [7:0] data_out,
output wire get_TX_packet_data,
output wire clear_timer, 
output wire count_enable, 
output wire clear_crc,
output wire load_enable,
output wire eop,
output wire busy,
output wire [1:0] control_data,
output wire crc_enable

);

//TX_packet
//
//00 ACK 
//01 NACK
//10 DATA
//11 IDLE
//
//

reg  [7:0] out_data_out;
reg out_get_TX_packet_data;
reg out_clear_timer; 
reg out_count_enable; 
reg out_clear_crc;
reg out_load_enable;
reg out_eop;
reg out_busy; 
reg [1:0] out_control_data; 
reg out_crc_enable; 
reg out_crc_flag; 

typedef enum bit[4:0] {IDLE, START, SYNC, LOAD_PID, NACK, SEND_NACK, ACK, SEND_ACK, SEND_DATA_PID, SEND1, CLEAR_TIMER, DATA_PID, LOAD_DATA, SEND_DATA, WAIT_CRC, LOAD_CRC1, SEND_CRC1, LOAD_CRC2, SEND_CRC2, EOP1, EOP2, WAIT_TIMER1, WAIT_TIMER2, END1, END2}stateType; 

stateType state;
stateType next_state; 

always_ff @ (posedge clk, negedge n_rst) begin
	if(!n_rst) begin 
		state <= IDLE; 
	end 

	else begin
		state <= next_state; 
	end
end 

always_comb begin
	next_state = state;
	
	case(state) 
		IDLE:
			if(TX_packet == 2'b11) begin
				next_state = IDLE; 
			end

			else begin
				next_state = START;
			end

		START: next_state = SYNC;

		SYNC: 
			if(rollover_flag2) begin
				next_state = LOAD_PID; 
			end 

			else begin
				next_state = SYNC;
			end 

		LOAD_PID: 
			if(TX_packet == 2'b00) begin
				next_state = ACK;
			end 

			else if (TX_packet == 2'b01) begin
				next_state = NACK; 
			end

			else if (TX_packet == 2'b10) begin
				next_state = SEND_DATA_PID;
			end 

			else begin
				next_state = LOAD_PID;
			end

		NACK:	next_state = SEND_NACK;
		
		SEND_NACK: 
			if(rollover_flag2) begin
				next_state =  WAIT_TIMER1; 
			end

			else begin
				next_state = SEND_NACK;
			end 

		ACK:	next_state = SEND_ACK; 

		SEND_ACK: 
			if(rollover_flag2) begin
				next_state = WAIT_TIMER1; 
			end 

			else begin
				next_state = SEND_ACK; 
			end 

		SEND_DATA_PID: next_state = SEND1;

		SEND1:	
			if(rollover_flag2) begin
				next_state = CLEAR_TIMER; 
			end 

			else begin 
				next_state = SEND1; 
			end

		CLEAR_TIMER: next_state = DATA_PID; 

		DATA_PID: 
			if (rollover_flag3) begin
				next_state = WAIT_CRC; 
			end
			else begin
				next_state = LOAD_DATA;
			end

		LOAD_DATA: next_state = SEND_DATA;

		SEND_DATA: 

			if (rollover_flag2) begin
				next_state = DATA_PID;
			end 

			else begin
				next_state = SEND_DATA; 
			end 

		WAIT_CRC: 
			if(crc_done) begin 
				next_state = LOAD_CRC1;
			end 
			else begin
				next_state = WAIT_CRC;
			end 
		
		LOAD_CRC1: next_state = SEND_CRC1;

		SEND_CRC1:
			if(rollover_flag2) begin
				next_state = LOAD_CRC2;
			end 

			else begin
				next_state = SEND_CRC1; 
			end 
		LOAD_CRC2: next_state = SEND_CRC2;

		SEND_CRC2: 
			if(rollover_flag2) begin
				next_state = WAIT_TIMER1; 
			end 

			else begin
				next_state = SEND_CRC2;
			end 
		WAIT_TIMER1: next_state = EOP1; 

		EOP1:
			if(rollover_flag1) begin
				next_state = WAIT_TIMER2;
			end 

			else begin
				next_state = EOP1; 
			end
		WAIT_TIMER2: next_state = EOP2;

		EOP2:
			if(rollover_flag1) begin
				next_state = END1;
			end 

			else begin
				next_state = EOP2; 
			end 
		END1: 	
			if(rollover_flag1) begin
				next_state = END2; 
			end 
			else begin
				next_state = END1;
			end 
		END2: 
			if(rollover_flag1) begin
				next_state = IDLE;
			end
			else begin
				next_state = END2;
			end 
		default: next_state = IDLE;  
	endcase
end 

always_comb begin
	out_data_out = '0;
	out_get_TX_packet_data = '0; 
	out_clear_timer = '0; 
	out_count_enable = '0; 
	out_clear_crc = '0;
	out_load_enable = '0;
	out_eop = '0;
	out_busy = '1;
	out_control_data = '0;
	out_crc_enable = '0;
	out_crc_flag = '0;
	
	if(state == IDLE) begin
		out_clear_timer = '1;
		out_count_enable = '0;
		out_busy = 0;
	end 

	else if(state == START) begin
		out_data_out =  8'b10000000;
		out_load_enable = '1; 
		out_control_data = 2'b00;
	end 

	else if(state == SYNC) begin
		out_count_enable = 1'b1; 
	end 

	else if(state == LOAD_PID) begin
		out_clear_timer = 1; 
		out_count_enable = 0;
	end

	else if(state == ACK) begin
		out_data_out = 8'b00101101; // ack pid
		out_load_enable = 1;
		out_control_data = 2'b00;
	end 

	else if(state == SEND_ACK) begin
		out_count_enable = 1;
	end 

	else if(state == NACK) begin
		out_data_out = 8'b10100101; // nack pid
		out_load_enable = 1;
		out_control_data = 2'b00;	
	end 

	else if(state == SEND_NACK) begin
		out_count_enable = 1;
	end 

	else if( state == SEND_DATA_PID) begin
		out_data_out = 8'b00111100; // DATA0 pid
		out_load_enable = 1;
		out_control_data = 2'b00;

	end 

	else if( state == SEND1) begin
		out_count_enable = 1;
	end 

	else if (state == CLEAR_TIMER) begin
		out_clear_timer =1; 
		out_clear_crc = 1; 
	end 

	else if(state == DATA_PID) begin
		out_get_TX_packet_data = 1;
		out_count_enable = 0;
	end 

	else if (state == LOAD_DATA) begin
		out_load_enable = 1;
		out_control_data = 2'b01;
	end 

	else if (state == SEND_DATA) begin
		out_count_enable = 1;
		out_crc_enable = 1;
	end 


	else if (state == WAIT_CRC) begin
		out_crc_flag = 1 ;
	end 

	else if (state == LOAD_CRC1) begin
		out_load_enable = 1;
		out_control_data = 2'b10; 
		out_clear_timer =1; 
	end 

	else if (state == SEND_CRC1) begin
		out_count_enable = 1;
	end 

	else if (state == LOAD_CRC2) begin
		out_load_enable = 1; 
		out_control_data = 2'b11;
		out_clear_timer = 1;
	end 

	else if (state == SEND_CRC2) begin
		out_count_enable = 1; 
	end 
	else if (state == EOP1) begin
		out_eop = 1;
		out_count_enable = 1;
	end

	else if (state == EOP2) begin
		out_eop = 1;
		out_clear_crc = 1;
		out_count_enable = 1;
	end

	else if (state == WAIT_TIMER1) begin
		out_count_enable = 0;
		out_clear_timer = 1; 	
	end 
	else if (state == WAIT_TIMER2) begin
		out_count_enable = 0;
		out_clear_timer = 1; 	
	end 
	else if (state == END1) begin
		out_count_enable = 1;
	end 
	else if (state == END2) begin
		out_count_enable = 1;
	end 

end 

assign data_out = out_data_out;
assign get_TX_packet_data = out_get_TX_packet_data; 
assign clear_timer = out_clear_timer; 
assign count_enable = out_count_enable; 
assign clear_crc = out_clear_crc;
assign load_enable = out_load_enable;
assign eop = out_eop;
assign busy = out_busy;
assign control_data = out_control_data; 
assign crc_enable = out_crc_enable; 
assign crc_done = out_crc_flag;
endmodule
