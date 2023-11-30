`timescale 1ns / 1ps

module render(
    input clk,
    input vga_clk,
    output hsync,
    output vsync,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b
    );

    wire [9:0] pixel_x;
    wire [9:0] pixel_y;
    wire [15:0] addr;
    wire [15:0] addra;
    wire is_apple;

    vga_sync m0 (
        .vga_clk(vga_clk),
        .rst(1'b0),
        .hsync(hsync),
        .vsync(vsync),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );

    reg [9:0] pos_x = 0;
    reg [9:0] pos_y = 0;
    assign addr = pixel_x - pos_x + (pixel_y - pos_y) ? 800 : 0;
    assign addra = (addr < 484) ? addr : 0;
    assign is_appple = (pixel_x - pos_x < 22 && pixel_x - pos_x > 0 &&
                        pixel_y - pos_y < 22 && pixel_y - pos_y > 0) 
                        ? 1'b1 : 1'b0;

    apple m1 (
        .addra(addra),
        .douta(rgb_data),
        .clka(clk)
    );

    assign {r, g, b} = is_apple ? rgb_data : 12'h000;

endmodule
