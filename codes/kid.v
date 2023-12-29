module kid
#(
    parameter init_x = 200,
    parameter init_y = 556
)
(
    input clk,
    input toggle_clk,
    input update_clk,
    input [9:0] col,
    input [9:0] row,
    input [3:0] keys,
    output is_kid,
    output [11:0] kid_rgb
);

    localparam kid_w = 31;
    localparam kid_h = 23;

    integer pos_x = init_x;
    integer pos_y = init_y;

    reg [1:0] cnt = 0;

    wire in_box, kid_dir;
    wire [1:0] kid_action;
    wire [3:0] is_move, is_collide;
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

    always @(posedge toggle_clk) begin
        cnt <= cnt + 1;
    end

    always @(posedge update_clk) begin
        if (is_move[0] && !is_collide[0]) begin
            pos_y = pos_y - 1;
        end
        if (is_move[1] && !is_collide[1]) begin
            pos_y = pos_y + 1;
        end
        if (is_move[2] && !is_collide[2]) begin
            pos_x = pos_x - 1;
        end
        if (is_move[3] && !is_collide[3]) begin
            pos_x = pos_x + 1;
        end
    end

    collide_det CollisionDetector (
        .clk(clk),
        .kid_t((kid_action == 2'b10) ? pos_y : pos_y + 3),
        .kid_b(pos_y + 22),
        .kid_l(pos_x + 9),
        .kid_r(pos_x + 21),
        .is_collide(is_collide)
    );

    action_update ActionUpdater (
        .clk(update_clk),
        .keys(keys),
        .direction(kid_dir),
        .action(kid_action),
        .is_move(is_move)
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
