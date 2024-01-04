module end_scene (
    input clk,
    input [9:0] col,
    input [9:0] row,
    output is_end_scene,
    output [11:0] end_scene_rgb
);

    parameter gameover_w = 800;
    parameter gameover_h = 165;
    parameter pos_x = 0;
    parameter pos_y = 216;

    wire in_box;
    wire [17:0] gameover_addr;

    assign in_box = (col - pos_x >= 0 && col - pos_x < gameover_w &&
                     row - pos_y >= 0 && row - pos_y < gameover_h) 
                     ? 1'b1 : 1'b0;
    assign gameover_addr = in_box ? (col - pos_x) + (row - pos_y) * gameover_w : 1'b0;
    assign is_end_scene = (in_box && end_scene_rgb ^ 12'hFFF) ? 1'b1 : 1'b0;

    gameover Gameover (
        .addra(gameover_addr),
        .douta(end_scene_rgb),
        .clka(clk)
    );

endmodule
