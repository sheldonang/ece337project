module flex_pts_sr_TX
#(
parameter NUM_BITS =8,
parameter SHIFT_MSB = 1 //1 = MSB , 0 = LSB
)
(
input wire clk, 
input wire n_rst, 
input wire shift_enable,
input wire load_enable, 
input reg [NUM_BITS -1: 0] parallel_in, 
output wire serial_out
);

reg [NUM_BITS -1:0] next_par;
reg [NUM_BITS-1:0] current_par;
reg temp;

always_ff @ (posedge clk, negedge n_rst) begin 
	if(!n_rst) begin
		current_par <= '1;
	end
	else begin
		current_par <= next_par; 
	end
end

always_comb begin
	next_par = current_par;

	if(load_enable) begin
		next_par = parallel_in; 
	end
	else if(shift_enable) begin
		if(SHIFT_MSB == 1'b1) begin
			next_par = {current_par[NUM_BITS -2:0],1'b1};
		end
		if(SHIFT_MSB == 1'b0) begin
			next_par = {1'b1,current_par[NUM_BITS-1:1]};
		end
	end
end

//assign serial_out = temp;
always_comb begin
	if(SHIFT_MSB == 1'b1) begin
		temp = current_par[NUM_BITS -1]; 
	end
	if(SHIFT_MSB == 1'b0) begin
		temp = current_par[0];
	end
end

assign serial_out = temp; 
endmodule
