`timescale 1ns / 1ps

module kid
#(
    parameter init_x = 60,
    parameter init_y = 558
)
(
    input clk,
    input toggle_clk,
    input update_clk,
    input [9:0] col,
    input [9:0] row,
    input [7:0] keycode,
    output is_kid,
    output [11:0] kid_rgb,
    output [9:0] kid_x
);

    parameter RUN_W = 26;
    parameter RUN_H = 23;
    parameter JUMP_W = 18;
    parameter JUMP_H = 23;
    parameter FALL_W = 27;
    parameter FALL_H = 20;

    assign is_kid = 1'b0;
    assign kid_rgb = 12'b0;
    assign kid_x = init_x;

endmodule
