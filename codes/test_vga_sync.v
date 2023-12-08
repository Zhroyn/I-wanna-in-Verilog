`timescale 1ns / 1ps

module test_vga_sync;

    // Inputs
    reg vga_clk;
    reg clrn;

    // Outputs
    wire hsync;
    wire vsync;
    wire [9:0] col;
    wire [9:0] row;

    // Instantiate the Unit Under Test (UUT)
    vga_sync uut (
        .vga_clk(vga_clk), 
        .clrn(clrn), 
        .hsync(hsync), 
        .vsync(vsync), 
        .col(col), 
        .row(row)
    );

    integer i;
    initial begin
        vga_clk = 0;
        clrn = 1;
        i = 0;
        #1;
        for (i = 0; i < 2_000_000; i = i + 1) begin
            vga_clk = ~vga_clk;
            #1;
        end
    end
      
endmodule

