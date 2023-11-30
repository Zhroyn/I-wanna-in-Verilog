`timescale 1ns / 1ps

module clk_test;

	// Inputs
	reg clk;

	// Outputs
	wire vga_clk;
	wire update_clk;

	clk_50mhz m0 (
		.clk(clk),
		.vga_clk(vga_clk)
	);
	clk_50hz m1 (
		.clk(clk),
		.update_clk(update_clk)
	);

	integer i;

	initial begin
		clk = 0;
		i = 0;
		#1;
		for (i = 0; i < 10_000_000; i = i + 1) begin
			clk = ~clk;
			#1;
		end
	end
      
endmodule

