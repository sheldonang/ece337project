// $Id: $
// File name:   adder_1bit.sv
// Created:     8/28/2019
// Author:      Sheldon Ang
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: 1 bit adder

module adder_1bit
(
input wire a, 
input wire b, 
input wire carry_in,
output wire sum,
output wire carry_out
);

wire xor1;

assign xor1 = (a ^ b);
assign sum = (carry_in ^ xor1);
assign carry_out = ((~carry_in) & b & a) | (carry_in &(b|a));

endmodule
