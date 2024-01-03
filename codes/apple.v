module apple
#(
    parameter init_x = 0,
    parameter init_y = 0,
    parameter trig_x = 0,
    parameter trig_y = 1,
    parameter move_dir = 1
)
(
    input clk,
    input rst,
    input toggle_clk,
    input update_clk,
    input [9:0] col,
    input [9:0] row,
    input [9:0] kid_x,
    input [9:0] kid_y,
    output is_apple,
    output is_collide,
    output [11:0] apple_rgb
);

    localparam apple_w = 22;
    localparam apple_h = 24;
    localparam screen_w = 800;
    localparam screen_h = 600;

    reg cnt = 0;
    reg is_triggered = 0;
    reg [9:0] pos_x = init_x;
    reg [9:0] pos_y = init_y;

    wire in_box;
    wire out_of_screen;
    wire [9:0] bound_l, bound_r, bound_t, bound_b;
    wire [10:0] apple_addr;

    assign in_box = (col - pos_x >= 0 && col - pos_x < apple_w &&
                     row - pos_y >= 0 && row - pos_y < apple_h) 
                     ? 1'b1 : 1'b0;
    assign apple_addr = in_box ? col - pos_x + (row - pos_y) * apple_w + cnt * apple_w * apple_h : 0;
    assign is_apple = (in_box && apple_rgb ^ 12'hFFF) ? 1'b1 : 1'b0;
    assign out_of_screen = (pos_y + apple_h < 0 || pos_y >= screen_h) ? 1'b1 : 1'b0;

    assign bound_l = pos_x - 10'd3;
    assign bound_r = pos_x + apple_w + 10'd3;
    assign bound_t = pos_y - 10'd7;
    assign bound_b = pos_y + apple_h + 10'd7;
    assign is_collide = (kid_x >= bound_l && kid_x < bound_r &&
                         kid_y >= bound_t && kid_y < bound_b) ? 1'b1 : 1'b0;

    always @(posedge toggle_clk) begin
        cnt <= cnt + 1;
    end

    always @(posedge clk) begin
        if (rst) begin
            is_triggered = 1'b0;
        end else if ((kid_x == pos_x + trig_x) && 
            ((trig_y == 1 && kid_y > pos_y || trig_y == -1 && kid_y < pos_y))) begin
            is_triggered = 1'b1;
        end
    end

    always @(posedge update_clk) begin
        if (rst) begin
            pos_y = init_y;
        end else if (is_triggered && !out_of_screen) begin
            pos_y = pos_y + move_dir;
        end
    end

    Apple Apple (
        .addra(apple_addr),
        .douta(apple_rgb),
        .clka(clk)
    );

endmodule
