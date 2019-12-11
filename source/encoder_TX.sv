module encoder_TX
(
input wire clk, 
input wire n_rst, 
input wire serial_in, 
input wire EOP, 
input wire shift,
input wire shift2,
output reg dplus,
output reg dminus 
);

reg out_dplus;
reg out_dminus; 

typedef enum bit[2:0]{IDLE, ONE, ZERO, ZERO_WAIT, END1, END2} stateType; 

stateType state; 
stateType next_state;


always_ff @ (posedge clk, negedge n_rst) begin
	if(!n_rst) begin
		state <= IDLE;
	end 

	else begin
		state <= next_state; 
		dplus <= out_dplus;
		dminus <= out_dminus;

	end
end 

always_comb begin
	next_state = state; 

	case (state) 
		IDLE:
			if(serial_in && (shift || shift2) ) begin
				next_state = ONE; 
			end

			else if(!serial_in && (shift || shift2) ) begin
				next_state = ZERO; 
			end
			
		//	else if(EOP && (shift || shift2) ) begin
		//		next_state = END1;
		//	end

			else begin
				next_state = IDLE;
			end 

		ONE:
			if(EOP && (shift || shift2) ) begin
				next_state = END1;
			end
			else if(!serial_in && (shift || shift2) ) begin
				next_state = ZERO; 
			end

			else if(serial_in && (shift || shift2) ) begin
				next_state = ONE; 
			end

			else begin
				next_state = ONE; 
			end 

		ZERO: 
			next_state = ZERO_WAIT; 
			//if(!serial_in && (shift || shift2) ) begin
			//	next_state = ZERO; 
			//end

			//else if(serial_in && (shift || shift2) ) begin
			//	next_state = ONE; 
			//end

			//else if(EOP && (shift || shift2) ) begin
			//	next_state = END1;
			//end

			//else begin
			//	next_state = ZERO;
			//end 

		ZERO_WAIT: 
			if(EOP && (shift || shift2) ) begin
				next_state = END1;
			end

			else if(!serial_in && (shift || shift2) ) begin
				next_state = ZERO; 
			end

			else if(serial_in && (shift || shift2) ) begin
				next_state = ONE; 
			end

			else begin
				next_state = ZERO_WAIT;
			end 


		END1: 
			if( EOP && shift) begin
				next_state = END2;
			end
			else begin
				next_state = END1;
			end

		END2: 
			if(shift) begin
				next_state = IDLE;
			end
			else begin
				next_state = END2;
			end

		default: next_state = IDLE; 
	endcase
end

always_comb begin
	out_dplus = '0;
	out_dminus = '0; 

	if(state == IDLE) begin
		out_dplus = '1; 
		out_dminus = '0; 
	end 

	else if(state == ONE) begin
		out_dplus = dplus; 
		out_dminus = dminus; 
	end

	else if(state == ZERO) begin
		out_dplus = !dplus; 
		out_dminus = !dminus; 	
	end 

	else if(state == ZERO_WAIT) begin
		out_dplus = dplus; 
		out_dminus = dminus; 	
	end 



	else if(state == END1) begin
		out_dplus = '0; 
		out_dminus = '0;

	end 

	else if(state == END2) begin
		out_dplus = '0; 
		out_dminus = '0; 

	end 

end

endmodule
