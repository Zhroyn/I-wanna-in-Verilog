module button (
    input clk,
    input rst,
    input [9:0] col,
    input [9:0] row,
    input [9:0] kid_x,
    input [9:0] kid_y,
    input [39:0] bullet_x,
    input [39:0] bullet_y,
    output is_button,
    output [11:0] button_rgb
);

    parameter button_w = 32;
    parameter button_h = 32;
    parameter pos_x = 95;
    parameter pos_y = 320;
    
    integer i;
    reg is_triggered = 0;

    wire in_box;
    wire [9:0] bound_l, bound_r, bound_t, bound_b;
    wire [9:0] button_addr;
    wire [11:0] unsaved_rgb, saved_rgb;

    assign in_box = (col - pos_x >= 0 && col - pos_x < button_w &&
                     row - pos_y >= 0 && row - pos_y < button_h) 
                     ? 1'b1 : 1'b0;
    assign button_addr = in_box ? col - pos_x + (row - pos_y) * button_w: 1'b0;
    assign is_button = (in_box && button_rgb ^ 12'hFFF) ? 1'b1 : 1'b0;
    assign button_rgb = is_triggered ? saved_rgb : unsaved_rgb;

    assign bound_l = pos_x - 10'd1;
    assign bound_r = pos_x + button_w + 10'd1;
    assign bound_t = pos_y - 10'd1;
    assign bound_b = pos_y + button_h + 10'd1;

    always @(posedge clk) begin
        if (rst) begin
            is_triggered = 1'b0;
        end else if (kid_x < 300 && kid_y < 400) begin
            for (i = 0; i < 4; i = i + 1) begin
                if ((bullet_x[(i*10+9)-:10] >= bound_l && bullet_x[(i*10+9)-:10] < bound_r &&
                     bullet_y[(i*10+9)-:10] >= bound_t && bullet_y[(i*10+9)-:10] < bound_b)) begin
                    is_triggered = 1'b1;
                end
            end
        end
    end

    save UnsavedButton (
        .addra(button_addr),
        .douta(unsaved_rgb),
        .clka(clk)
    );
    saved SavedButton (
        .addra(button_addr),
        .douta(saved_rgb),
        .clka(clk)
    );

endmodule
