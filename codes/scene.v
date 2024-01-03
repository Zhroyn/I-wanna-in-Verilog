module scene (
    input clk,
    input [9:0] col,
    input [9:0] row,
    output [11:0] scene_rgb
);

    parameter scene_w = 800;
    parameter scene_h = 600;

    wire [18:0] scene_addr = col + row * scene_w;

    background Background (
        .addra(scene_addr),
        .douta(scene_rgb),
        .clka(clk)
    );

endmodule
