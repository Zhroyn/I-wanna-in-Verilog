`timescale 1ns / 1ps

module clk_50mhz(clk, vga_clk);
    input wire clk;
    output reg vga_clk = 0;
	 
    always @(posedge clk) begin
        vga_clk <= ~vga_clk;
    end

endmodule
