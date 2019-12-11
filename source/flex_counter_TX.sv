module flex_counter_TX
#(
parameter NUM_CNT_BITS = 4
)

(
input logic clk,
input logic n_rst,
input logic clear, 
input logic count_enable, 
input logic [NUM_CNT_BITS - 1: 0] rollover_val, 
output logic [NUM_CNT_BITS -1: 0] count_out,
output logic rollover_flag
);

logic [NUM_CNT_BITS-1:0]	next_count;
logic next_rollover; 

always_ff @ (posedge clk,negedge n_rst) begin
	if (!n_rst) begin
		count_out <= 0; 
		rollover_flag <= 1'b0;
	end
	else begin
		count_out <= next_count;
		rollover_flag <= next_rollover;
	end
end

always_comb begin
	next_count = count_out; 
	next_rollover = '0; 
	
	if(clear) begin
		next_count =0;
		next_rollover = 0;
	end
	else if(count_enable) begin
		if(count_out ==rollover_val) begin
			next_count = 1;
			next_rollover = 0;
		end
		else if(count_out == (rollover_val -1)) begin
			next_count = count_out+1;
			next_rollover = 1;
		end
		else begin
			next_count = count_out +1;
			next_rollover = 0;
		end
	end
end
endmodule
