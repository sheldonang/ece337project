module flex_counter1_TX
#(
parameter NUM_CNT_BITS = 4
)

(
input wire clk,
input wire n_rst,
input wire clear, 
input wire stuff_flag,
input wire count_enable, 
input wire eop,
input wire [NUM_CNT_BITS - 1: 0] rollover_val, 
output reg [NUM_CNT_BITS -1: 0] count_out,
output reg rollover_flag,
output reg rollover_flag4
);

reg [NUM_CNT_BITS-1:0]	next_count;
reg next_rollover; 
reg next_rollover4;

always_ff @ (posedge clk,negedge n_rst) begin
	if (!n_rst) begin
		count_out <= 0; 
		rollover_flag <= 1'b0;
	end
	else begin
		count_out <= next_count;
		rollover_flag <= next_rollover;
		rollover_flag4 <= next_rollover4;
	end
end

always_comb begin
	if(clear) begin
		next_count =0;
		next_rollover = 0;
		next_rollover4 = 0;
	end
	else if(count_enable) begin
		if (stuff_flag) begin
			next_count = count_out; 
			next_rollover = 0;
			next_rollover4 = '1;
			
		end 
		else if(count_out ==rollover_val) begin
			next_count = 1;
			next_rollover = 0;
			next_rollover4 = 0; 
		end
	
		else if((count_out == 5'd7) || (count_out == 5'd15) || (count_out == rollover_val -1)) begin	
			next_count = count_out+1;
			next_rollover = 1;
			next_rollover4 = 0;
		end

		else begin
			next_count = count_out +1;
			next_rollover = 0;
			next_rollover4 = 0; 
		end
	end
	else begin
		next_count = count_out;
		next_rollover = rollover_flag; 
		next_rollover4 = rollover_flag4; 
	end
end
endmodule
