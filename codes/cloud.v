`timescale 1ns / 1ps

module cloud
#(
    parameter init_x = 0,
    parameter init_y = 0
)
(
    input clk,
    input toggle_clk,
    input [9:0] col,
    input [9:0] row,
    output is_cloud,
    output [11:0] cloud_rgb
);

    parameter cloud_w = 58;
    parameter cloud_h = 32;

    reg [9:0] pos_x = init_x;
    reg [9:0] pos_y = init_y;
    reg cnt = 0;

    wire in_box;
    wire [10:0] cloud_addr;
    wire [11:0] cloud1_rgb;
    wire [11:0] cloud2_rgb;

    assign in_box = (col - pos_x >= 0 && col - pos_x < cloud_w &&
                     row - pos_y >= 0 && row - pos_y < cloud_h) 
                     ? 1'b1 : 1'b0;
    assign cloud_addr = in_box ? col - pos_x + (row - pos_y) * cloud_w : 0;
    assign cloud_rgb = (cnt == 0) ? cloud1_rgb : cloud2_rgb;

    always @(posedge toggle_clk) begin
        cnt <= cnt + 1;
    end

    cloud1 Cloud1 (
        .addra(cloud_addr),
        .douta(cloud1_rgb),
        .clka(clk)
    );
    cloud2 Cloud2 (
        .addra(cloud_addr),
        .douta(cloud2_rgb),
        .clka(clk)
    );


endmodule
