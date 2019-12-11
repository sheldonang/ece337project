module usb_TX(
input wire clk, 
input wire n_rst,
input wire [7:0] TX_packet_data,
input wire [6:0] TX_packet_data_size,
input wire [1:0] TX_packet, 
output wire get_TX_packet_data,
output wire Dminus_out,
output wire Dplus_out,
output wire busy
);

wire pts_serial_out;
wire sts_serial_out;
wire stuffed_serial_out; 
wire EOP; 
wire stuff_flag;
wire rollover_flag1; 
wire rollover_flag2;
wire rollover_flag3;
wire rollover_flag4; 
wire load_enable; 
wire [7:0] controller_data_out;
wire clear_timer;
wire count_enable;
wire clear_crc;
wire [15:0] crc_out; 
wire crc_flag; 
wire [1:0] control_data;
wire crc_enable; 

encoder_TX ENCODER(.clk(clk), .n_rst(n_rst), .serial_in(stuffed_serial_out), .EOP(EOP), .dplus(Dplus_out), .dminus(Dminus_out), .shift(rollover_flag1) , .shift2(rollover_flag4)); 

//bit_stuffer_TX BIT_STUFFER(.clk(clk), .n_rst(n_rst), .serial_in(sts_serial_out), .stuff_flag(stuff_flag), .serial_out(stuffed_serial_out), .shift(rollover_flag1), .shift2(rollover_flag4));

//sts_shift_register_TX SERIAL_SERIAL(.clk(clk), .n_rst(n_rst), .serial_in(pts_serial_out), .shift(rollover_flag1), .serial_out(sts_serial_out));

pts_8_shift_register_TX PARALLEL_SERIAL(.clk(clk), .n_rst(n_rst), .rollover_flag1(rollover_flag1), .load_enable(load_enable), .data_in(controller_data_out), .data_out(pts_serial_out), .crc_out(crc_out), .TX_packet_data(TX_packet_data), .control_data(control_data));

bit_stuffer_TX BIT_STUFFER(.clk(clk), .n_rst(n_rst), .serial_in(pts_serial_out), .stuff_flag(stuff_flag), .serial_out(stuffed_serial_out), .shift(rollover_flag1), .shift2(rollover_flag4));

CRC_generator_TX CRC( .clk(clk) , .n_rst(n_rst), .sts_serial_out(pts_serial_out), .crc_flag(crc_flag), .crc_out(crc_out) , .clear_crc(clear_crc), .enable(crc_enable), .rollover_flag1(rollover_flag1));

timer_TX TIMER(.clk(clk), .n_rst(n_rst), .clear_timer(clear_timer), .count_enable(count_enable), .stuff_flag(stuff_flag), .rollover_flag1(rollover_flag1) , .rollover_flag2(rollover_flag2), .rollover_flag3(rollover_flag3), .rollover_flag4(rollover_flag4), .eop(EOP), .TX_packet_size(TX_packet_data_size)); 

//CRC_generator_TX CRC( .clk(clk) , .n_rst(n_rst), .sts_serial_out(sts_serial_out), .rollover_flag3(rollover_flag3), .crc_flag(crc_flag), .crc_out(crc_out) , .clear_crc(clear_crc));

controller_TX CONTROLLER ( .clk(clk), .n_rst(n_rst), .TX_packet(TX_packet) , .rollover_flag2(rollover_flag2) , .rollover_flag3(rollover_flag3) , .crc_done(crc_flag), .data_out(controller_data_out) , .get_TX_packet_data(get_TX_packet_data) , .clear_timer(clear_timer) , .count_enable(count_enable), .clear_crc(clear_crc) , .load_enable(load_enable) , .eop(EOP) , .busy(busy), .control_data(control_data), .rollover_flag1(rollover_flag1), .crc_enable(crc_enable)); 

endmodule 
