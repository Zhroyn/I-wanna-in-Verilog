`timescale 1ns / 1ps

module vga_sync(
    input vga_clk,
    input rst,
    output hsync,
    output vsync,
    output [9:0] pixel_x,
    output [9:0] pixel_y
    );

    // 800x600 @ 75Hz
    parameter H_SYNC = 80;
    parameter H_BACK = 160;
    parameter H_DISPLAY = 800;
    parameter H_FRONT = 16;

    parameter V_SYNC = 3;
    parameter V_FRONT = 1;
    parameter V_DISPLAY = 600;
    parameter V_BACK = 21;

    reg [9:0] hcount;
    reg [9:0] vcount;

    initial begin
        hcount = 0;
        vcount = 0;
    end

    always @(posedge vga_clk) begin
        if (rst) begin
            hcount <= 0;
            vcount <= 0;
        end else begin
            if (hcount == H_SYNC + H_BACK + H_DISPLAY + H_FRONT - 1) begin
                hcount <= 0;
                if (vcount == V_SYNC + V_BACK + V_DISPLAY + V_FRONT - 1) begin
                    vcount <= 0;
                end else begin
                    vcount <= vcount + 1;
                end
            end else begin
                hcount <= hcount + 1;
            end
        end
    end

    assign hsync = (hcount >= H_SYNC + H_BACK && hcount < H_SYNC + H_BACK + H_DISPLAY) ? 1'b1 : 1'b0;
    assign vsync = (vcount >= V_SYNC + V_BACK && vcount < V_SYNC + V_BACK + V_DISPLAY) ? 1'b1 : 1'b0;
    assign pixel_x = hcount - H_SYNC - H_BACK;
    assign pixel_y = vcount - V_SYNC - V_BACK;

endmodule
