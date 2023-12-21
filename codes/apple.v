`timescale 1ns / 1ps

module apple
#(
    parameter init_x = 0,
    parameter init_y = 0,
    parameter direction = 1
)
(
    input clk,
    input toggle_clk,
    input update_clk,
    input [9:0] col,
    input [9:0] row,
    input [9:0] kid_x,
    output is_apple,
    output [11:0] apple_rgb
);

    parameter apple_w = 22;
    parameter apple_h = 24;
    parameter screen_w = 800;
    parameter screen_h = 600;

    integer pos_x = init_x;
    integer pos_y = init_y;

    reg cnt = 0;
    reg is_triggered = 0;

    wire in_box;
    wire out_of_screen;
    wire [10:0] apple_addr;
    wire [11:0] apple1_rgb;
    wire [11:0] apple2_rgb;

    assign in_box = (col - pos_x >= 0 && col - pos_x < apple_w &&
                     row - pos_y >= 0 && row - pos_y < apple_h) 
                     ? 1'b1 : 1'b0;
    assign out_of_screen = (pos_y + apple_h < 0 || pos_y >= screen_h) ? 1'b1 : 1'b0;
    assign apple_addr = in_box ? col - pos_x + (row - pos_y) * apple_w : 0;
    assign apple_rgb = (cnt == 0) ? apple1_rgb : apple2_rgb;

    always @(posedge toggle_clk) begin
        cnt <= cnt + 1;
    end

    always @(posedge update_clk) begin
        if (kid_x >= pos_x - apple_w && kid_x < pos_x + apple_w) begin
            is_triggered = 1;
        end
        if (is_triggered && !out_of_screen) begin
            pos_y = pos_y + direction;
        end
    end

    apple1 Apple1 (
        .addra(apple_addr),
        .douta(apple1_rgb),
        .clka(clk)
    );
    apple2 Apple2 (
        .addra(apple_addr),
        .douta(apple2_rgb),
        .clka(clk)
    );

endmodule
