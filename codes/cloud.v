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

    localparam cloud_w = 58;
    localparam cloud_h = 32;

    reg [9:0] pos_x = init_x;
    reg [9:0] pos_y = init_y;
    reg cnt = 0;

    wire in_box;
    wire [11:0] cloud_addr;

    assign in_box = (col - pos_x >= 0 && col - pos_x < cloud_w &&
                     row - pos_y >= 0 && row - pos_y < cloud_h) 
                     ? 1'b1 : 1'b0;
    assign cloud_addr = in_box ? col - pos_x + (row - pos_y) * cloud_w + cnt * cloud_w * cloud_h : 1'b0;
    assign is_cloud = in_box;

    always @(posedge toggle_clk) begin
        cnt <= cnt + 1;
    end

    Cloud Cloud (
        .addra(cloud_addr),
        .douta(cloud_rgb),
        .clka(clk)
    );

endmodule
