module bullet (
    input clk,
    input rst,
    input update_clk,
    input [9:0] col,
    input [9:0] row,
    input [9:0] kid_x,
    input [9:0] kid_y,
    input kid_dir,
    input shoot,
    output is_bullet,
    output [9:0] bullet_x,
    output [9:0] bullet_y,
    output [11:0] bullet_rgb
);

    parameter bullet_w = 4;
    parameter bullet_h = 4;
    parameter screen_w = 800;
    parameter screen_h = 600;

    integer move_dir = 1;
    integer pos_x = screen_w + 1;
    integer pos_y = screen_h + 1;

    wire in_box;
    wire out_of_screen;
    wire [9:0] bound_l, bound_r, bound_t, bound_b;
    wire [10:0] bullet_addr;

    assign in_box = (col - pos_x >= 0 && col - pos_x < bullet_w &&
                     row - pos_y >= 0 && row - pos_y < bullet_h) 
                     ? 1'b1 : 1'b0;
    assign bullet_addr = in_box ? col - pos_x + (row - pos_y) * bullet_w : 1'b0;
    assign is_bullet = (in_box && bullet_rgb ^ 12'hFFF) ? 1'b1 : 1'b0;
    assign out_of_screen = (pos_x + bullet_w < 0 || pos_x >= screen_w) ? 1'b1 : 1'b0;
    assign bullet_x = pos_x + 1;
    assign bullet_y = pos_y + 1;

    always @(posedge update_clk) begin
        if (rst) begin
            pos_x = screen_w + 1;
            pos_y = screen_h + 1;
        end else begin
            if (shoot) begin
                move_dir = kid_dir ? 1 : -1;
                pos_x = kid_x;
                pos_y = kid_y;
            end else begin
                if (!out_of_screen) begin
                    pos_x = pos_x + move_dir;
                end
            end
        end
    end

    Bullet Bullet (
        .addra(bullet_addr),
        .douta(bullet_rgb),
        .clka(clk)
    );

endmodule
