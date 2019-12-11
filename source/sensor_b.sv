// $Id: $
// File name:   sensor_b.sv
// Created:     8/28/2019
// Author:      Sheldon Ang
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Behavioral Style Sensor Error Detector

module sensor_b
(
input wire [3:0] sensors, output reg error
);


always_comb begin
	error = 1'b0; 
	if ((sensors[2] == 1) | (sensors[3] == 1)) begin 
		if( sensors[1] == 1) begin 
			error = 1'b1;
		end
	end
	
	if(sensors[0] == 1) begin
		error = 1'b1;
	end
end	

endmodule
