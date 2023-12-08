`timescale 1ns / 1ps

module top(
    input clk,
    input [15:0] SW,
    output hsync,
    output vsync,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b
    );

    wire [31:0] clk_div;
    clkdiv m0 (
        .clk(clk),
        .clkdiv(clk_div)
    );

    render m2 (
        .clk(clk),
        .clrn(SW[0]),
        .vga_clk(clk_div[0]),
        .hsync(hsync),
        .vsync(vsync),
        .r(r),
        .g(g),
        .b(b)
    );

endmodule
