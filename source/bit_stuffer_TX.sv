module bit_stuffer_TX
(
	input wire clk,
	input wire n_rst,
	input wire serial_in,
	input wire shift,
	input wire shift2, 
	output wire stuff_flag, 
	output wire serial_out
); 

reg out_serial_out;
reg out_stuff_flag;

typedef enum bit[2:0]{IDLE, STUFF1, STUFF2, STUFF3, STUFF4, STUFF5, STUFF6, RESUME} stateType; 
stateType state; 
stateType next_state; 

always_ff @ (posedge clk, negedge n_rst) begin
	if (!n_rst) begin
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
			if (serial_in && (shift) ) begin
				next_state = STUFF1;
			end

			else if (!serial_in && (shift || shift2)  ) begin
				next_state = IDLE; 
			end

			else begin
				next_state = IDLE; 
			end 

		STUFF1:
			if (serial_in && (shift)  ) begin
				next_state = STUFF2;
			end

			else if (!serial_in && (shift || shift2)  ) begin
				next_state = IDLE; 
			end
			else begin
				next_state = STUFF1 ; 
			end 


		STUFF2:
			if (serial_in && (shift)  ) begin
				next_state = STUFF3;
			end

			else if (!serial_in && (shift || shift2)  ) begin
				next_state = IDLE; 
			end
			else begin
				next_state = STUFF2; 
			end 


		STUFF3:
			if (serial_in && (shift)  ) begin
				next_state = STUFF4;
			end

			else if (!serial_in && (shift || shift2)  ) begin
				next_state = IDLE; 
			end
			else begin
				next_state = STUFF3; 
			end 

		STUFF4:
			if (serial_in && (shift)  ) begin
				next_state = STUFF5;
			end

			else if (!serial_in && (shift || shift2)  ) begin
				next_state = IDLE; 
			end
			else begin
				next_state = STUFF4; 
			end 

		STUFF5: 
			if (serial_in && (shift)  ) begin
				next_state = STUFF6;
			end

			else if (!serial_in && (shift || shift2)  ) begin
				next_state = IDLE; 
			end
			else begin
				next_state = STUFF5; 
			end 

		STUFF6: 
			next_state = RESUME;

		RESUME:
			if (serial_in && (shift || shift2)  ) begin
				next_state = IDLE; 
			end

			else if (!serial_in && (shift || shift2)  )  begin
				next_state = IDLE;
			end 

			else begin
				next_state = RESUME; 
			end

		default: next_state = IDLE; 
	endcase
end 

always_comb begin
	out_serial_out = '0;
	out_stuff_flag = '0; 

	if( state == IDLE) begin
		out_serial_out = serial_in;
		out_stuff_flag = '0; 
	end 

	else if( state == STUFF1) begin
		out_serial_out = serial_in;
		out_stuff_flag = '0; 
	end 

	else if( state == STUFF2) begin
		out_serial_out = serial_in;
		out_stuff_flag = '0; 
	end 

	else if( state == STUFF3) begin
		out_serial_out = serial_in;
		out_stuff_flag = '0; 
	end 

	else if( state == STUFF4) begin
		out_serial_out = serial_in;
		out_stuff_flag = '0; 
	end 

	else if( state == STUFF5) begin
		out_serial_out = serial_in;
		out_stuff_flag = '0; 
	end 

	else if( state == STUFF6) begin
		out_serial_out = serial_in;
		out_stuff_flag = '0; 
	end 

	else if( state == RESUME) begin
		out_serial_out = '0;
		out_stuff_flag = '1; 
	end 

end 

assign serial_out = out_serial_out; 
assign stuff_flag = out_stuff_flag;

endmodule
