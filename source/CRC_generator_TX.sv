
module CRC_generator_TX
(
  input wire clk,
  input wire n_rst,
  input wire clear_crc,
  input wire rollover_flag1, 
  input wire sts_serial_out, // msb 1st
  input wire enable,
  output reg [15:0] crc_out,
  input wire crc_flag
);
reg [15:0] next_crc_out;

always_ff @ (posedge clk, negedge n_rst) begin 
	if (!n_rst) begin 
		crc_out <= '1;
	end 	
	else begin
		crc_out <= next_crc_out;
	end 

end 

always_comb begin
	next_crc_out = crc_out; 

	if (clear_crc) begin
		next_crc_out = '1;
	end 
	else if (enable && rollover_flag1) begin
		next_crc_out[15] = crc_out[14] ^ crc_out[15] ^ sts_serial_out;
        	next_crc_out[14:3] = crc_out[13:2];
        	next_crc_out[2] = crc_out[1] ^ crc_out[15] ^ sts_serial_out;
        	next_crc_out[1] = crc_out[0];
        	next_crc_out[0] = crc_out[15] ^ sts_serial_out;
	end 	
	else if(crc_flag) begin
		next_crc_out = ~crc_out; 
	end
 
end 

endmodule 
