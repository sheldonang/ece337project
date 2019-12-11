// $Id: $
// File name:   sensor_d.sv
// Created:     8/28/2019
// Author:      Sheldon Ang
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Dataflow Style Sensor Error Detector


module sensor_d
(
input wire[3:0] sensors, output wire error
);

wire orOut1;
wire andOut1;

assign orOut1 = sensors[2] | sensors[3];
assign andOut1 = orOut1 & sensors[1];
assign error = andOut1 | sensors[0];

endmodule
