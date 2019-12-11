module sts_shift_register_TX
(
 input wire clk,
 input wire n_rst, 
 input wire serial_in,
 input wire shift,
 output reg serial_out
);

reg [7:0] temp;
reg [7:0] next_temp;
reg next_serial_out; 

always_ff @ (posedge clk, negedge n_rst) begin
	if(!n_rst) begin
		temp <= '0; 
		serial_out <= '0; 
	end 

	else begin
		temp <= next_temp;
		serial_out <= next_serial_out;
	end 
end 

always_comb begin
	next_temp = temp; 
	next_serial_out = serial_out;
	if(shift) begin
		next_temp = {serial_in,temp[7:1]};
		next_serial_out = temp[0];
	end 
end 

endmodule
