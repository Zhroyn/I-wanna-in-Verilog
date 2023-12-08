`timescale 1ns / 1ps

module test_render;

    // Inputs
    reg clk;
    reg clrn;
    reg vga_clk;

    // Outputs
    wire hsync;
    wire vsync;
    wire [3:0] r;
    wire [3:0] g;
    wire [3:0] b;

    // Instantiate the Unit Under Test (UUT)
    render uut (
        .clk(clk), 
        .clrn(clrn), 
        .vga_clk(vga_clk), 
        .hsync(hsync), 
        .vsync(vsync), 
        .r(r), 
        .g(g), 
        .b(b)
    );

    integer i;
    initial begin
        clrn = 1;
        clk = 0;
        vga_clk = 0;
        i = 0;
        #1;
        for (i = 0; i < 1_000_000; i = i + 1) begin
            vga_clk = ~vga_clk;
            clk = ~clk;
            #1;
        end
    end
      
endmodule