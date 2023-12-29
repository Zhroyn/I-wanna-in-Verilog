`timescale 1ns / 1ps

module test_cloud;

    reg clk;
    reg vga_clk;
    reg toggle_clk;

    wire hsync;
    wire vsync;
    wire [9:0] col;
    wire [9:0] row;
    wire is_cloud;
    wire [11:0] cloud_rgb;

    vga_sync vga_sync (
        .vga_clk(vga_clk),
        .clrn(1'b1),
        .hsync(hsync),
        .vsync(vsync),
        .col(col),
        .row(row)
    );

    cloud #(.init_x(64), .init_y(91)) cloud (
        .clk(clk),
        .toggle_clk(toggle_clk),
        .col(col),
        .row(row),
        .is_cloud(is_cloud),
        .cloud_rgb(cloud_rgb)
    );

    integer i;
    initial begin
        clk = 0;
        vga_clk = 0;
        toggle_clk = 0;
        #1;
        for (i = 0; i < 2_000_000; i = i + 1) begin
            clk = ~clk;
            vga_clk = ~vga_clk;
            toggle_clk = ~toggle_clk;
            #1;
        end
    end
      
endmodule
