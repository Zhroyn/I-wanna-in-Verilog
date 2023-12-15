`timescale 1ns / 1ps

module render(
    input clk,
    input clrn,
    input vga_clk,
    output hsync,
    output vsync,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b
    );

    parameter SCREEN_W = 800;
    parameter SCREEN_H = 600;
    parameter APPLE_W = 22;
    parameter APPLE_H = 24;

    wire [9:0] col;
    wire [9:0] row;

    reg [9:0] pos_x = 0;
    reg [9:0] pos_y = 0;

    wire is_bg = (col >= 0 && col < SCREEN_W && row >= 0 && row < SCREEN_H) 
                 ? 1'b1 : 1'b0;
    wire [18:0] bg_addr = is_bg ? col + row * SCREEN_W : 0;
    wire [11:0] bg_rgb;

    wire is_apple = (col - pos_x >= 0 && col - pos_x < APPLE_W &&
                    row - pos_y >= 0 && row - pos_y < APPLE_H) 
                    ? 1'b1 : 1'b0;
    wire [10:0] apple_addr = is_apple ? col - pos_x + (row - pos_y) * APPLE_W : 0;
    wire [11:0] apple_rgb;


    vga_sync m0 (
        .vga_clk(vga_clk),
        .clrn(clrn),
        .hsync(hsync),
        .vsync(vsync),
        .col(col),
        .row(row)
    );
    background m1 (
        .addra(bg_addr),
        .douta(bg_rgb),
        .clka(clk)
    );
    apple1 m2 (
        .addra(apple_addr),
        .douta(apple_rgb),
        .clka(clk)
    );

    assign {r, g, b} = (is_apple && apple_rgb !== 12'hFFF) ? apple_rgb : bg_rgb;

endmodule
