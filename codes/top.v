`timescale 1ns / 1ps

module top(
    input clk,
    input ps2_clk,
    input ps2_data,
    input [15:0] SW,
    output hsync,
    output vsync,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b
    );

    wire [31:0] clk_div;
    wire [7:0] keycode;

    clkdiv ClkDiv (
        .clk(clk),
        .clkdiv(clk_div)
    );

    keycode_driver KeyBoard (
        .clk(clk),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .keycode(keycode)
    )

    render Render (
        .clk(clk),
        .clkdiv(clk_div),
        .clrn(SW[0]),
        .vga_clk(clk_div[0]),
        .hsync(hsync),
        .vsync(vsync),
        .r(r),
        .g(g),
        .b(b)
    );

endmodule
