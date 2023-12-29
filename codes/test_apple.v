`timescale 1ns / 1ps

module test_apple;

    reg clk;
    reg vga_clk;
    reg toggle_clk;
    reg update_clk;

    wire hsync;
    wire vsync;
    wire [9:0] col;
    wire [9:0] row;
    wire is_apple;
    wire [11:0] apple_rgb;

    vga_sync vga_sync (
        .vga_clk(vga_clk),
        .clrn(1'b1),
        .hsync(hsync),
        .vsync(vsync),
        .col(col),
        .row(row)
    );

    apple #(.init_x(64), .init_y(91)) apple (
        .clk(clk),
        .toggle_clk(toggle_clk),
        .update_clk(update_clk),
        .col(col),
        .row(row),
        .kid_x(0),
        .is_apple(is_apple),
        .apple_rgb(apple_rgb)
    );

    integer i;
    initial begin
        clk = 0;
        vga_clk = 0;
        toggle_clk = 0;
        update_clk = 0;
        #1;
        for (i = 0; i < 2_000_000; i = i + 1) begin
            clk = ~clk;
            vga_clk = ~vga_clk;
            toggle_clk = ~toggle_clk;
            update_clk = ~update_clk;
            #1;
        end
    end
      
endmodule
