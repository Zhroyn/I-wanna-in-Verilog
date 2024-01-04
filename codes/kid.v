module kid (
    input clk,
    input rst,
    input toggle_clk,
    input update_clk,
    input [9:0] col,
    input [9:0] row,
    input [3:0] keys,
    output is_kid,
    output [11:0] kid_rgb,
    output [9:0] kid_x,
    output [9:0] kid_y
);

    localparam kid_w = 31;
    localparam kid_h = 23;

    reg [1:0] cnt = 0;

    wire in_box, kid_dir;
    wire [1:0] kid_action;
    wire [3:0] is_collide;
    wire [9:0] pos_x, pos_y;
    wire [9:0] kid_addr_x;
    wire [11:0] kid_addr;
    wire [11:0] idle_rgb, run_rgb, jump_rgb, fall_rgb;

    assign in_box = (col - pos_x >= 0 && col - pos_x < kid_w &&
                     row - pos_y >= 0 && row - pos_y < kid_h) 
                     ? 1'b1 : 1'b0;
    assign kid_addr_x = kid_dir ? col - pos_x : kid_w - 1 - (col - pos_x);
    assign kid_addr = in_box ? kid_addr_x + (row - pos_y) * kid_w + cnt * kid_w * kid_h : 1'b0;
    assign is_kid = (in_box && kid_rgb ^ 12'hFFF) ? 1'b1 : 1'b0;
    assign kid_rgb = (kid_action == 2'b00) ? idle_rgb :
                     (kid_action == 2'b01) ? run_rgb :
                     (kid_action == 2'b10) ? jump_rgb :
                     (kid_action == 2'b11) ? fall_rgb : 12'hFFF;
    assign kid_x = pos_x + 15;
    assign kid_y = pos_y + 11;

    always @(posedge toggle_clk) begin
        cnt <= cnt + 1'b1;
    end

    collide_det CollisionDetector (
        .clk(update_clk),
        .kid_t((kid_action == 2'b10) ? pos_y : pos_y + 10'd3),
        .kid_b(pos_y + 10'd22),
        .kid_l(pos_x + 10'd9),
        .kid_r(pos_x + 10'd21),
        .is_collide(is_collide)
    );

    state_update KidStateUpdater (
        .clk(update_clk),
        .rst(rst),
        .keys(keys),
        .is_collide(is_collide),
        .direction(kid_dir),
        .action(kid_action),
        .pos_x(pos_x),
        .pos_y(pos_y)
    );

    idle Idle (
        .addra(kid_addr),
        .douta(idle_rgb),
        .clka(clk)
    );
    running Running (
        .addra(kid_addr),
        .douta(run_rgb),
        .clka(clk)
    );
    jumping Jumping (
        .addra(kid_addr),
        .douta(jump_rgb),
        .clka(clk)
    );
    falling Falling (
        .addra(kid_addr),
        .douta(fall_rgb),
        .clka(clk)
    );

endmodule
