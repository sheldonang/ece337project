// $Id: $
// File name:   sensor_s.sv
// Created:     8/28/2019
// Author:      Sheldon Ang
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Sensor Error Detector.
//

module sensor_s
(
input wire [3:0] sensors, output wire error
);

wire andOut1;
wire orOut1;
wire orOut2;

OR2X1 A1 (.Y(orOut1), .A(sensors[2]), .B(sensors[3]));
AND2X1 A2 (.Y(andOut1), .A(orOut1), .B(sensors[1]));
OR2X1 A3 (.Y(error), .A(andOut1), .B(sensors[0])); 

endmodule 
 
