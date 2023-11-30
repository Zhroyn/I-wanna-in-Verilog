`timescale 1ns / 1ps

module top(
    input wire clk,
    output wire hsync,
    output wire vsync,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b
    );

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

    render m2 (
        .clk(clk),
        .vga_clk(vga_clk),
        .hsync(hsync),
        .vsync(vsync),
        .r(r),
        .g(g),
        .b(b)
    );

endmodule
