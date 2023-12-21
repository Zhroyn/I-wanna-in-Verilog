`timescale 1ns / 1ps

module scene
(
    input clk,
    input [9:0] col,
    input [9:0] row,
    output [11:0] scene_rgb
);

    parameter scene_w = 800;
    parameter scene_h = 600;

    wire in_box;
    wire [18:0] scene_addr;

    assign in_box = (col >= 0 && col < scene_w &&
                     row >= 0 && row < scene_h) 
                     ? 1'b1 : 1'b0;
    assign scene_addr = in_box ? col + row * scene_w : 0;

    background Background (
        .addra(scene_addr),
        .douta(scene_rgb),
        .clka(clk)
    );

endmodule
