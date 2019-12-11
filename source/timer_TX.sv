module timer_TX
(
	input logic clk,
	input logic n_rst,
	input logic clear_timer,
	input logic count_enable,
	input logic stuff_flag, 
	input logic  eop,
	input logic [6:0] TX_packet_size,
	output logic rollover_flag3,
	output logic rollover_flag2,
	output logic rollover_flag1,  
	output logic rollover_flag4 
);

logic [4:0] count1;
logic [3:0] count2; 
logic [6:0] count3; 

	flex_counter1_TX #(5) counter1 (.clk(clk), .n_rst(n_rst),.clear(clear_timer),.count_enable(count_enable),.rollover_val(5'd25),.count_out(count1),.rollover_flag(rollover_flag1), .stuff_flag(stuff_flag), .rollover_flag4(rollover_flag4), .eop(eop));

	flex_counter_TX #(4) counter2 (.clk(clk), .n_rst(n_rst),.clear(clear_timer),.count_enable(rollover_flag1),.rollover_val(4'b1000),.count_out(count2),.rollover_flag(rollover_flag2));
	
	flex_counter_TX #(7) counter3 (.clk(clk), .n_rst(n_rst),.clear(clear_timer),.count_enable(rollover_flag2),.rollover_val(TX_packet_size),.count_out(count3),.rollover_flag(rollover_flag3));

endmodule
