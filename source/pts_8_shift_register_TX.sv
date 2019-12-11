module pts_8_shift_register_TX
(
  input wire clk,
  input wire n_rst,
  input wire rollover_flag1,
  input wire load_enable,
  input wire [7:0] data_in,
  input wire [15:0] crc_out,
  input wire [7:0] TX_packet_data, 
  input wire [1:0] control_data,
  output reg data_out 
);

wire [7:0] data; 

assign data = (control_data == 2'b00) ? data_in : (control_data == 2'b01) ? TX_packet_data : (control_data == 2'b10) ? crc_out[7:0] : (control_data == 2'b11) ? crc_out[15:8] : '0;   

//always_comb begin
//	if(control_data == 2'b00) begin
//		data = data_in; 
//	end
//
//	else if(control_data == 2'b01) begin
//		data = TX_packet_data;
//	end 
//
//	else if(control_data == 2'b10) begin 
//		data = crc_out[7:0]; 
//	end 
//
//	else if(control_data == 2'b11) begin
//		data  = crc_out[15:8]; 
//	end 
//
//	else begin
//		data = data_in;
//	end
//end 
//choose data between sync/pid(data_in), TX_packet_data, crc_out[7:0] and crc_out[15:8]

  flex_pts_sr_TX #(.SHIFT_MSB(0)) CORE(.clk(clk),.n_rst(n_rst),.parallel_in(data),.shift_enable(rollover_flag1),.load_enable(load_enable),.serial_out(data_out));

endmodule
