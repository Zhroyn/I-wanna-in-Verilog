`timescale 1ns / 1ps

module test_read_rom;

	// Inputs
	reg clk;

	// Outputs
	wire [3:0] r;
	wire [3:0] g;
	wire [3:0] b;

	// Instantiate the Unit Under Test (UUT)
	read_rom uut (
		.clk(clk), 
		.r(r), 
		.g(g), 
		.b(b)
	);

	integer i;
	initial begin
		clk = 0;
		#1;
		for (i = 0; i < 960_000; i = i + 1) begin
			clk = ~clk;
			#1;
		end
	end
      
endmodule
